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
    var title: String? { get }
    var progress: Double { get }
    var downloadSpeed: String? { get }
}

class DownloadingCellViewModel: DownloadingCellViewModeling {
    
    let title: String?
    let progress: Double
    let downloadSpeed: String?
    
    init(torrent: Torrent) {
        self.title = torrent.name
        self.progress = Double(360 * (torrent.progress ?? 0 / 100))
        let (speed, unit) = torrent.downloadPayloadrate?.inUnits() ?? (0, .byte)
        self.downloadSpeed = "\(speed), \(unit)"
    }
}

public enum Unit: String {
    case byte, kb, mb, gb
    
    func stringified() -> String {
        
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
    
    func stringifiedAsSpeed() -> String {
        
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

extension Double {
    
    func inUnits() -> (Double, Unit) {
        
        if self >= 1073741824 {
            let size = (self / 1073741824).setPrecision(to: 1)
            return (size, .gb)
        }
        
        if self >= 1048576 {
            let size = (self / 1048576).setPrecision(to: 1)
            return (size, .mb)
        }
        
        if self >= 1024 {
            let size = (self / 1024).setPrecision(to: 1)
            return (size, .kb)
        }
        
        return (self, .byte)
        
    }
    
    func setPrecision(to: Int) -> Double {
        
        let divisor = pow(10.0, Double(1))
        return (self * divisor).rounded() / divisor
        
    }
    
}

extension TorrentState {
    
    func toColor() -> UIColor {
        
        switch self {
        case .seeding:
            return UIColor.green
        case .paused:
            return UIColor.gray
        case .error:
            return UIColor.red
        case .downloading:
            return UIColor.blue
        case .queued:
            return UIColor.yellow
        case .unknown:
            return UIColor.gray
        }
        
    }
    
}
