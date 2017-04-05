//
//  DelugionServiceMock.swift
//  Deluge
//
//  Created by Yotam Ohayon on 14/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import Delugion
@testable import Deluge

class DelugionServiceMock: DelugionServicing {
    
    var checkSessionTest: Bool!
    var checkSession: Observable<Bool> {
        return Observable.just(checkSessionTest)
    }
    
    var loginTest: Bool!
    var login: Observable<Bool> {
        return Observable.just(loginTest)
    }
    
    var connectedTest: Bool!
    var connected: Observable<Bool> {
        return Observable.just(connectedTest)
    }
    
    var hostsTest: [Host]!
    var hosts: Observable<[Host]> {
        return Observable.just(hostsTest)
    }
    
    var torrentsTest: [TorrentProtocol]!
    var torrents: Observable<[TorrentProtocol]> {
        return Observable.just(torrentsTest)
    }
    
    var hostStatusTest: Host!
    func hostStatus(hash: String) -> Observable<Host> {
        return Observable.just(hostStatusTest)
    }
    
    func connect(hash: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    var torrentInfoTest: TorrentProtocol!
    func torrentInfo(hash: String) -> Observable<TorrentProtocol> {
        return Observable.just(torrentInfoTest)
    }
    
    var torrentFilesTest: TorrentContent!
    func torrentFiles(hash: String) -> Observable<TorrentContent> {
        return Observable.just(torrentFilesTest)
    }
    
    var removeTorrentTest: Bool!
    func removeTorrent(hash: String,
                       withData shouldRemoveData: Bool) -> Observable<Bool> {
        return Observable.just(removeTorrentTest)
    }
    
    func resumeTorrent(hash: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func pauseTorrent(hash: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    var getMagnetInfoTest: MagnetInfo!
    func getMagnetInfo(url: URL) -> Observable<MagnetInfo> {
        return Observable.just(getMagnetInfoTest)
    }
    
    var addTorrentTest: Bool!
    func addTorrent(url: URL) -> Observable<Bool> {
        return Observable.just(addTorrentTest)
    }
    
    static var torrentFileMock: TorrentFile {
        return TorrentFile(priority: 1,
                           index: 1,
                           offset: 1,
                           path: "path",
                           progress: 1.0,
                           size: 1,
                           type: "file",
                           progresses: nil,
                           contents: nil)
    }
    
    static var torrenContent: TorrentContent {
        return TorrentContent(contents: ["file": DelugionServiceMock.torrentFileMock])
    }
    
}
