//
//  PausedCellViewModeling.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

protocol PausedCellViewModeling {
    var title: String? { get }
    var progress: Double { get }
    var progressNumeric: String? { get }
}

class PausedCellViewModel: PausedCellViewModeling {
    
    let title: String?
    let progress: Double
    let progressNumeric: String?
    
    init(torrent: TorrentProtocol) {
        self.title = torrent.name
        if let progress = torrent.progress {
            self.progress = Double(3.6 * progress)
            self.progressNumeric = String(describing: progress.setPrecision(to: 0))
        }
        else {
            self.progress = 0
            self.progressNumeric = nil
        }
        
    }
}
