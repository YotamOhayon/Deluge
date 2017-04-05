//
//  DelugionService.swift
//  Deluge
//
//  Created by Yotam Ohayon on 06/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion
import RxSwift
import SwiftyBeaver
import RxOptional

protocol DelugionServicing {
    
    var checkSession: Observable<Bool> { get }
    var login: Observable<Bool> { get }
    var connected: Observable<Bool> { get }
    var hosts: Observable<[Host]> { get }
    var torrents: Observable<[TorrentProtocol]> { get }
    
    func hostStatus(hash: String) -> Observable<Host>
    func connect(hash: String) -> Observable<Void>
    func torrentInfo(hash: String) -> Observable<TorrentProtocol>
    func torrentFiles(hash: String) -> Observable<TorrentContent>
    func removeTorrent(hash: String,
                       withData shouldRemoveData: Bool) -> Observable<Bool>
    func resumeTorrent(hash: String) -> Observable<Void>
    func pauseTorrent(hash: String) -> Observable<Void>
    func getMagnetInfo(url: URL) -> Observable<MagnetInfo>
    func addTorrent(url: URL) -> Observable<Bool>
    
}

class DelugionService: DelugionServicing {
    
    let checkSession: Observable<Bool>
    let login: Observable<Bool>
    let connected: Observable<Bool>
    let hosts: Observable<[Host]>
    let torrents: Observable<[TorrentProtocol]>
    let delugion: Observable<Delugion>
    
    private let disposeBag = DisposeBag()
    private let timeout: RxTimeInterval = 5
    private let dataRefreshRate: RxTimeInterval = 1
    
    init(settings: SettingsServicing) {
        
        let hostAndPortObservable = Observable.combineLatest(settings.host.filterNil(),
                                                             settings.port.filterNil())
        
        self.delugion = hostAndPortObservable
            .map { hostname, port in
                return try? Delugion(hostname: hostname, port: port)
            }
            .filterNil()
            .share(replay: 1, scope: .forever)
        
        self.checkSession = delugion.flatMapLatest { delugion in
            Observable<Bool>.create { observer in
                delugion.checkSession { response in
                    switch response {
                    case .valid(let val): observer.onNext(val)
                    default: break
                    }
                }
                return Disposables.create()
            }
        }
        
        self.login = Observable
            .combineLatest(settings.password.filterNil(), delugion)
            .flatMapLatest { password, delugion in
                Observable<Bool>.create { observer in
                    delugion.login(withPassword: password) { response in
                        switch response {
                        case .valid(let val): observer.onNext(val)
                        default: break
                        }
                    }
                    return Disposables.create()
                }
        }
        
        self.connected = delugion.flatMapLatest { delugion in
            Observable<Bool>.create { observer in
                delugion.connected { response in
                    switch response {
                    case .valid(let val): observer.onNext(val)
                    default: break
                    }
                }
                return Disposables.create()
            }
        }
        
        self.hosts = delugion.flatMapLatest { delugion in
            Observable<[Host]>.create { observer in
                delugion.getHosts { response in
                    switch response {
                    case .valid(let val): observer.onNext(val)
                    default: break
                    }
                }
                return Disposables.create()
            }
        }
        
        self.torrents = delugion.flatMapLatest { delugion in
            Observable<[TorrentProtocol]>.create { observer -> Disposable in
                let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                                 repeats: true)
                { _ in
                    delugion.updateUI(filterByState: nil) { response in
                        switch response {
                        case .error(_):
                            break
                        case .valid(let v):
                            observer.onNext(v)
                        }
                    }
                }
                return Disposables.create {
                    timer.invalidate()
                }
            }
        }
        
    }
    
    func hostStatus(hash: String) -> Observable<Host> {
        return delugion.flatMapLatest { delugion in
            Observable<Host>.create { observer in
                delugion.getHostStatus(hash: hash) { response in
                    switch response {
                    case .valid(let val): observer.onNext(val)
                    default: break
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    func connect(hash: String) -> Observable<Void> {
        return delugion.flatMapLatest { delugion in
            Observable<Void>.create { observer in
                delugion.connect(hash: hash) { response in
                    switch response {
                    case .valid(_): observer.onNext(())
                    default: break
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    func torrentInfo(hash: String) -> Observable<TorrentProtocol> {
        let interval = Observable<Int>.interval(dataRefreshRate,
                                                scheduler: MainScheduler.instance)
        return Observable
            .combineLatest(delugion, interval) { delugion, _ in
                delugion
            }
            .flatMapLatest { delugion in
                delugion.rx.getTorrentStatus(hash: hash)
        }
    }
    
    func torrentFiles(hash: String) -> Observable<TorrentContent> {
        let interval = Observable<Int>.interval(dataRefreshRate,
                                                scheduler: MainScheduler.instance)
        return Observable
            .combineLatest(delugion, interval) { delugion, _ in
                delugion
            }
            .flatMapLatest { delugion in
                delugion.rx.getTorrentFiles(hash: hash)
        }
    }
    
    func removeTorrent(hash: String,
                       withData shouldRemoveData: Bool) -> Observable<Bool> {
        return self.delugion.flatMapLatest { delugion in
            delugion.rx.remove(hash: hash, withData: shouldRemoveData)
        }
    }
    
    func resumeTorrent(hash: String) -> Observable<Void> {
        return self.delugion.flatMapLatest { delugion in
            delugion.rx.resume(hash: hash)
        }
    }
    
    func pauseTorrent(hash: String) -> Observable<Void> {
        return self.delugion.flatMapLatest { delugion in
            delugion.rx.pause(hash: hash)
        }
    }
    
    func getMagnetInfo(url: URL) -> Observable<MagnetInfo> {
        return self.delugion.flatMapLatest { delugion in
            delugion.rx.getMagnetInfo(url: url)
        }
    }
    
    func addTorrent(url: URL) -> Observable<Bool> {
        return self.delugion.flatMapLatest { delugion in
            delugion.rx.addTorrents(url: url)
        }
    }
    
}
