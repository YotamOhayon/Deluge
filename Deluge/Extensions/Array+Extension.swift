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
            return self.sorted(by: { $0.0.queue > $0.1.queue })
        case .downloadSpeed:
            return self.sorted(by: { $0.0.downloadPayloadrate > $0.1.downloadPayloadrate })
        case .uploadSpeed:
            return self.sorted(by: { $0.0.uploadPayloadrate > $0.1.uploadPayloadrate })
        }
    }
    
}
