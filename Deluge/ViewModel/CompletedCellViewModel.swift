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
        
        guard let title = torrent.name, let totalSize = torrent.totalSize else {
            self.title = nil
            self.size = nil
            return
        }
        
        self.title = title
        let (size, unit) = totalSize.inUnits(withPrecision: 1)
        self.size = "\(size) \(unit.stringified)"
        
    }
    
}
