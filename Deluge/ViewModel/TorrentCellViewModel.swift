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
    var progressNumeric: Int? { get }
    var torrent: TorrentProtocol { get }
    
}

class TorrentCellViewModel: TorrentCellViewModeling {
    
    static let reuseIdentifier = "TorrentCell"
    
    let title: String?
    let progress: Double
    let themeColor: UIColor
    let progressNumeric: Int?
    let torrent: TorrentProtocol
    
    init(torrent: TorrentProtocol, themeManager: ThemeManaging) {
        
        self.title = torrent.name
        
        self.progress = Double(3.6 * torrent.progress)
        self.themeColor = themeManager.color(forTorrentState: torrent.state)
        self.progressNumeric = Int(torrent.progress)
        self.torrent = torrent
        
    }
}
