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
    
    let connectionResponse: ServerResponse<Bool>
    let torrentsResponse: ServerResponse<[TorrentProtocol]>
    let torrentResponse: ServerResponse<TorrentProtocol>
    
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
    
}
