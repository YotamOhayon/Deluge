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
    var progress: Double? { get }
}

class PausedCellViewModel: PausedCellViewModeling {
    
    let title: String?
    let progress: Double?
    
    init(torrent: Torrent) {
        self.title = torrent.name
        self.progress = torrent.progress
    }
}
