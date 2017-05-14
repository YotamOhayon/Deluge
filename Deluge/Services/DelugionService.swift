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

protocol DelugionServicing {
    
    var connection: Observable<ServerResponse<Void>> { get }
    var torrents: Observable<ServerResponse<[TorrentProtocol]>> { get }
    
    func torrentInfo(hash: String) -> Observable<ServerResponse<TorrentProtocol>>
    func torrentFiles(hash: String) -> Observable<ServerResponse<TorrentContent>>
    func removeTorrent(hash: String, withData
        shouldRemoveData: Bool,
                       completion: @escaping (ServerResponse<Void>) -> Void)
    func resumeTorrent(hash: String, completion: @escaping () -> Void)
    func pauseTorrent(hash: String, completion: @escaping () -> Void)
    
}

class DelugionService: DelugionServicing {
    
    let delugion: Observable<Delugion?>
    let connection: Observable<ServerResponse<Void>>
    let torrents: Observable<ServerResponse<[TorrentProtocol]>>
    let disposeBag = DisposeBag()
    
    init(settings: SettingsServicing) {
        
        let hostOrPortChanged = Observable.combineLatest(settings.hostObservable, settings.portObservable) {
            ($0, $1)
            }.shareReplay(1)
        
        self.delugion = hostOrPortChanged.map {
            guard let hostname = $0, let port = $1 else {
                return nil
            }
            return try? Delugion(hostname: hostname, port: port)
            }.shareReplay(1)
        
        self.connection = Observable.combineLatest(settings.passwordObservable, delugion).flatMap { password, delugion in
            Observable.create { observer in
                guard let delugion = delugion, let password = password else {
                    return Disposables.create()
                }
                delugion.connect(withPassword: password) {
                    observer.onNext($0)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
        
        self.torrents = delugion.flatMap { delugion in
            Observable.create { observer -> Disposable in
                let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                                 repeats: true)
                { _ in
                    delugion?.info(filterByState: nil) {
                        observer.onNext($0)
                    }
                }
                return Disposables.create {
                    timer.invalidate()
                }
            }
        }
        
    }
    
    func torrentInfo(hash: String) -> Observable<ServerResponse<TorrentProtocol>> {
        return self.delugion.flatMap { delugion in
            return Observable.create { observer -> Disposable in
                let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                                 repeats: true)
                { _ in
                    delugion?.info(hash: hash) {
                        observer.onNext($0)
                    }
                }
                return Disposables.create {
                    timer.invalidate()
                }
            }
        }
    }
    
    func torrentFiles(hash: String) -> Observable<ServerResponse<TorrentContent>> {
        return self.delugion.flatMap { delugion in
            return Observable.create { observer -> Disposable in
                let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                                 repeats: true)
                { _ in
                    delugion?.getTorrentFiles(hash: hash) {
                        observer.onNext($0)
                    }
                }
                return Disposables.create {
                    timer.invalidate()
                }
            }
        }
    }
    
    func removeTorrent(hash: String, withData shouldRemoveData: Bool, completion: @escaping
        (ServerResponse<Void>) -> Void) {
        self.delugion.subscribe(onNext: { delugion in
            delugion?.remove(hash: hash, withData: shouldRemoveData) {
                completion($0)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func resumeTorrent(hash: String, completion: @escaping () -> Void) {
        self.delugion.subscribe(onNext: { delugion in
            delugion?.resume(hash: hash, completion: completion)
        }).disposed(by: self.disposeBag)
    }
    
    func pauseTorrent(hash: String, completion: @escaping () -> Void) {
        self.delugion.subscribe(onNext: { delugion in
            delugion?.pasue(hash: hash, completion: completion)
        }).disposed(by: self.disposeBag)
    }
    
}
