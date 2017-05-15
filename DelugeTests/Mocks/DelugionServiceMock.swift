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
    
    var connectionResponse: ServerResponse<Void>
    var torrentsResponse: ServerResponse<[TorrentProtocol]>
    var torrentResponse: ServerResponse<TorrentProtocol>
    var torrentFilesResponse: ServerResponse<TorrentContent>
    
    var connection: Observable<ServerResponse<Void>> {
        return Observable.just(self.connectionResponse)
    }
    
    var torrents: Observable<ServerResponse<[TorrentProtocol]>> {
        return Observable.just(self.torrentsResponse)
    }
    
    func torrentInfo(hash: String) -> Observable<ServerResponse<TorrentProtocol>> {
        return Observable.just(self.torrentResponse)
    }
    
    func torrentFiles(hash: String) -> Observable<ServerResponse<TorrentContent>> {
        return Observable.just(self.torrentFilesResponse)
    }
    
    func removeTorrent(hash: String, withData shouldRemoveData: Bool, completion: @escaping (ServerResponse<Void>) -> Void) {
        
    }
    
    func resumeTorrent(hash: String, completion: @escaping () -> Void) {
        
    }
    
    func pauseTorrent(hash: String, completion: @escaping () -> Void) {
        
    }
    
    func getMagnetInfo(url: URL, completion: @escaping (ServerResponse<MagnetInfo>) -> Void) {
        
    }
    
    func addTorrent(url: URL, completion: @escaping () -> Void) {
        
    }
    
    init(connectionResponse: ServerResponse<Void>,
         torrentsResponse: ServerResponse<[TorrentProtocol]>,
         torrentResponse: ServerResponse<TorrentProtocol>,
         torrentFilesResponse: ServerResponse<TorrentContent>) {
        
        self.connectionResponse = connectionResponse
        self.torrentsResponse = torrentsResponse
        self.torrentResponse = torrentResponse
        self.torrentFilesResponse = torrentFilesResponse
        
    }
    
    convenience init(connectionResponse: ServerResponse<Void>) {
        
        self.init(connectionResponse: connectionResponse,
                  torrentsResponse: .valid([TorrentMock()]),
                  torrentResponse: .valid(TorrentMock()),
                  torrentFilesResponse: .valid(DelugionServiceMock.torrenContent))
        
    }
    
    convenience init(torrentsResponse: ServerResponse<[TorrentProtocol]>) {
        
        self.init(connectionResponse: .valid(),
                  torrentsResponse: torrentsResponse,
                  torrentResponse: .valid(TorrentMock()),
                  torrentFilesResponse: .valid(DelugionServiceMock.torrenContent))
        
    }
    
    convenience init() {
        
        self.init(connectionResponse: .valid(),
                  torrentsResponse: .valid([TorrentMock()]),
                  torrentResponse: .valid(TorrentMock()),
                  torrentFilesResponse: .valid(DelugionServiceMock.torrenContent))
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
