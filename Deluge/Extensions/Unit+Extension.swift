//
//  Unit+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

enum Unit: String {
    
    case byte, kb, mb, gb
    
    var stringified: String {
        
        switch self {
        case .byte:
            return "B"
        case .kb:
            return "KB"
        case .mb:
            return "MB"
        case .gb:
            return "GB"
        }
        
    }
    
    var stringifiedAsSpeed: String {
        
        switch self {
        case .byte:
            return "B/s"
        case .kb:
            return "KB/s"
        case .mb:
            return "MB/s"
        case .gb:
            return "GB/s"
        }
        
    }
    
}
