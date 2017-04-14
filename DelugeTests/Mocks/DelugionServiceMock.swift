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
    
    var connectionResponse: ServerResponse<Bool>
    var torrentsResponse: ServerResponse<[TorrentProtocol]>
    var torrentResponse: ServerResponse<TorrentProtocol>
    
    var connection: Observable<ServerResponse<Bool>> {
        return Observable.just(self.connectionResponse)
    }
    
    var torrents: Observable<ServerResponse<[TorrentProtocol]>> {
        return Observable.just(self.torrentsResponse)
    }
    
    func torrentInfo(hash: String) -> Observable<ServerResponse<TorrentProtocol>> {
        return Observable.just(self.torrentResponse)
    }
    
    init(connectionResponse: ServerResponse<Bool>,
         torrentsResponse: ServerResponse<[TorrentProtocol]>,
         torrentResponse: ServerResponse<TorrentProtocol>) {
        
        self.connectionResponse = connectionResponse
        self.torrentsResponse = torrentsResponse
        self.torrentResponse = torrentResponse
        
    }
    
    convenience init(connectionResponse: ServerResponse<Bool>) {
        
        self.init(connectionResponse: connectionResponse,
                  torrentsResponse: .valid([TorrentMock()]),
                  torrentResponse: .valid(TorrentMock()))
        
    }
    
    convenience init(torrentsResponse: ServerResponse<[TorrentProtocol]>) {
        
        self.init(connectionResponse: .valid(true),
                  torrentsResponse: torrentsResponse,
                  torrentResponse: .valid(TorrentMock()))
        
    }
    
    convenience init() {
        self.init(connectionResponse: .valid(true),
                  torrentsResponse: .valid([TorrentMock()]),
                  torrentResponse: .valid(TorrentMock()))
    }
    
}
