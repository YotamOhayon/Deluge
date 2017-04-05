//
//  Unit.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

enum Unit {
    
    case B, KiB, MiB, GiB
    
    var stringified: String {
        
        switch self {
        case .B:
            return "B"
        case .KiB:
            return "KiB"
        case .MiB:
            return "MiB"
        case .GiB:
            return "GiB"
        }
        
    }
    
    var stringifiedAsSpeed: String {
        
        switch self {
        case .B:
            return "B/s"
        case .KiB:
            return "KiB/s"
        case .MiB:
            return "MiB/s"
        case .GiB:
            return "GiB/s"
        }
        
    }
    
}
