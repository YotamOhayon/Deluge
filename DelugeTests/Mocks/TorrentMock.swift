//
//  TorrentMock.swift
//  Deluge
//
//  Created by Yotam Ohayon on 14/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

class TorrentMock: TorrentProtocol {
    
    var torrentHash: String = "hash"
    
    var downloadPayloadrate: Double = 1
    
    var uploadPayloadrate: Double = 1
    
    var eta : Double = 1000
    
    var name: String = "torrent"
    
    var progress: Double = 1
    
    var ratio: Double = 1
    
    var state: TorrentState = .downloading
    
    var totalDone: Double  = 1
    
    var totalSize: Double = 1
    
    var totalUploaded: Double = 1
    
    var queue: Double = 1
    
}
