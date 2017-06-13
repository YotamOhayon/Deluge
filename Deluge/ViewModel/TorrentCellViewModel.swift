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
    var trackColor: UIColor { get }
    var progressColor: UIColor { get }
    var progressNumeric: Int? { get }
    var progressNumericColor: UIColor { get }
    var progressBackgroundColor: UIColor { get }
    var torrent: TorrentProtocol { get }
    
}

class TorrentCellViewModel: TorrentCellViewModeling {
    
    static let reuseIdentifier = "TorrentCell"
    
    let title: String?
    let progress: Double
    let trackColor: UIColor
    let progressColor: UIColor
    let progressNumeric: Int?
    let progressNumericColor: UIColor
    let progressBackgroundColor: UIColor
    let torrent: TorrentProtocol
    
    init(torrent: TorrentProtocol, themeManager: ThemeManaging) {
        
        self.title = torrent.name
        self.trackColor = themeManager.trackColor
        self.progress = Double(3.6 * torrent.progress)
        self.progressColor = themeManager.progressColor(forTorrentState: torrent.state)
        self.progressNumeric = Int(torrent.progress)
        self.progressNumericColor = themeManager.progressNumericColor(forTorrentState: torrent.state)
        self.progressBackgroundColor = themeManager.progressBackgroundColor(forTorrentState: torrent.state)
        self.torrent = torrent
        
    }
}
