//
//  TorrentState.swift
//  Pods
//
//  Created by Yotam Ohayon on 14/04/2017.
//
//

import Foundation

public enum TorrentState: String {
    
    case seeding = "Seeding"
    case paused = "Paused"
    case error = "Error"
    case downloading = "Downloading"
    case queued = "Queued"
    case checking = "Checking"
    
}

extension TorrentState: CustomStringConvertible {
    
    public var description: String {
        return self.rawValue
    }
    
}
