//
//  Array+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

extension Array where Element == TorrentProtocol {
    
    func sorted(by sortBy: SortBy) -> [Element] {
        switch sortBy {
        case .priority:
            return self.sorted(by: { $0.queue > $1.queue })
        case .downloadSpeed:
            return self.sorted(by: { $0.downloadPayloadrate > $1.downloadPayloadrate })
        case .uploadSpeed:
            return self.sorted(by: { $0.uploadPayloadrate > $1.uploadPayloadrate })
        }
    }
    
}
