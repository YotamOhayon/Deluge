//
//  CompletedCellViewModeling.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

protocol CompletedCellViewModeling {
    var title: String? { get }
    var size: String? { get }
}

class CompletedCellViewModel: CompletedCellViewModeling {
    
    let title: String?
    let size: String?
    
    init(torrent: TorrentProtocol) {
        
        self.title = torrent.name
        let (size, unit) = torrent.totalSize.inUnits(withPrecision: 1)
        self.size = "\(size) \(unit.stringified)"
        
    }
    
}
