//
//  DownloadingCellViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

protocol DownloadingCellViewModeling {
    var text: String? { get }
}

class DownloadingCellViewModel: DownloadingCellViewModeling {
    
    var text: String?
    
    init(torrent: Torrent) {
        self.text = torrent.name
    }
}
