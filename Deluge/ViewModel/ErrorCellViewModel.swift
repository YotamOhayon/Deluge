//
//  ErrorCellViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

protocol ErrorCellViewModeling {
    var title: String? { get }
}

class ErrorCellViewModel: ErrorCellViewModeling {
    
    let title: String?
    
    init(torrent: TorrentProtocol) {
        self.title = torrent.name
    }
    
}
