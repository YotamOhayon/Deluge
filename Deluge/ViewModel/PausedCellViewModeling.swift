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
    var text: String? { get }
}

class PausedCellViewModel: PausedCellViewModeling {
    
    var text: String?
    
    init(torrent: Torrent) {
        self.text = torrent.name
    }
}
