//
//  ThemeService.swift
//  Deluge
//
//  Created by Yotam Ohayon on 16/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import Delugion

protocol ThemeServicing {
    
    var torrentCell: TorrentCellTheme { get }
    var torrentDetails: TorrentDetailsTheme { get }
    
}

class ThemeService: ThemeServicing {
    
    let torrentCell = TorrentCellTheme()
    let torrentDetails = TorrentDetailsTheme()
    
}

struct TorrentCellTheme {
    
    var titleColor = UIColor(red: 3, green: 3, blue: 3)
    
    func subtitleColor(forTorrentState state: TorrentState) -> UIColor {
        if state == .error {
            return UIColor(red: 254, green: 56, blue: 36)
        } else {
            return UIColor(red: 143, green: 143, blue: 143)
        }
    }
    
    func progressColor(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .downloading:
            return UIColor(red: 0, green: 122, blue: 255)
        case .seeding:
            return UIColor(red: 0, green: 117, blue: 255)
        default:
            return UIColor(red: 199, green: 199, blue: 204)
        }
    }
    
}

struct TorrentDetailsTheme {
    
    func subtitleColor(forTorrentState state: TorrentState) -> UIColor {
        if state == .error {
            return UIColor(red: 254, green: 56, blue: 36)
        } else {
            return UIColor(red: 143, green: 143, blue: 143)
        }
    }
    
    func progressColor(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .downloading:
            return UIColor(red: 0, green: 122, blue: 255)
        case .seeding:
            return UIColor(red: 0, green: 117, blue: 255)
        default:
            return UIColor(red: 199, green: 199, blue: 204)
        }
    }
    
    var blueButton = UIColor(red: 0, green: 118, blue: 255)
    var redButton = UIColor(red: 254, green: 56, blue: 36)
    var buttonBackground = UIColor(red: 255, green: 255, blue: 255)
    
}
