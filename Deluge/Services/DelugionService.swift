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
    
}

class DelugionService: DelugionServicing {
    
    var connection: Observable<ServerResponse<Void>> {
        return Observable.create { [unowned self] observer -> Disposable in
            self.delugion.connect(withPassword: "Y6412257") {
                observer.onNext($0)
            }
            return Disposables.create()
        }
    }
    
    var torrents: Observable<ServerResponse<[TorrentProtocol]>> {
        return Observable.create { [unowned self] observer -> Disposable in
            let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                             repeats: true) { [unowned self] _ in
                                                self.delugion.info(filterByState: nil) {
                                                    observer.onNext($0)
                                                }
            }
            return Disposables.create {
                timer.invalidate()
            }
        }
    }
    
    let delugion: Delugion
    
    init(delugion: Delugion) {
        self.delugion = delugion
    }
    
    func torrentInfo(hash: String) -> Observable<ServerResponse<TorrentProtocol>> {
        return Observable.create { [unowned self] observer -> Disposable in
            let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                             repeats: true)
            { [unowned self] _ in
                self.delugion.info(hash: hash) {
                    observer.onNext($0)
                }
            }
            return Disposables.create {
                timer.invalidate()
            }
        }
    }
    
    func torrentFiles(hash: String) -> Observable<ServerResponse<TorrentContent>> {
        return Observable.create { [unowned self] observer -> Disposable in
            let timer = Timer.scheduledTimer(withTimeInterval: 1,
                                             repeats: true)
            { [unowned self] _ in
                self.delugion.getTorrentFiles(hash: hash) {
                    observer.onNext($0)
                }
            }
            return Disposables.create {
                timer.invalidate()
            }
        }
    }
    
}
