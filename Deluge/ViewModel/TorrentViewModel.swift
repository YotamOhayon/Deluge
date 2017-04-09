//
//  TorrentViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

protocol TorrentModeling {
    var title: String? { get }
}

class TorrentModel: TorrentModeling {
    
    let title: String?
    
    init(torrent: Torrent) {
        self.title = torrent.name
    }
    
}
