//
//  TorrentCellViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

protocol TorrentCellViewModeling {
    
    var title: String? { get }
    var progress: Double { get }
    var themeColor: UIColor { get }
    var progressNumeric: Double? { get }
    var torrent: TorrentProtocol { get }
    
}

class TorrentCellViewModel: TorrentCellViewModeling {
    
    let title: String?
    let progress: Double
    let themeColor: UIColor
    let progressNumeric: Double?
    let torrent: TorrentProtocol
    
    init(torrent: TorrentProtocol) {
        
        self.title = torrent.name
        
        self.progress = Double(3.6 * torrent.progress)
        self.themeColor = { () -> UIColor in
            switch torrent.state {
            case .seeding: return .green
            case .paused: return .gray
            case .error: return .red
            case .downloading: return .blue
            case .queued: return .green
            case .checking: return .green
            }
        }()
        self.progressNumeric = torrent.progress.setPrecision(to: 0)
        self.torrent = torrent
        
    }
}
