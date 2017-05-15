//
//  SortBy.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

enum SortBy: Int, CustomStringConvertible {
    
    case priority, downloadSpeed, uploadSpeed
    
    var description: String {
        switch self {
        case .priority:
            return "Priority"
        case .downloadSpeed:
            return "Download Speed"
        case .uploadSpeed:
            return "Upload Speed"
        }
    }
    
    static var allValues: [SortBy] {
        var values = [SortBy]()
        var i = 0
        while let newVal = SortBy(rawValue: i) {
            values.append(newVal)
            i += 1
        }
        return values
    }
    
}
