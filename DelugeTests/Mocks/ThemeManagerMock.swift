//
//  ThemeManagerMock.swift
//  Deluge
//
//  Created by Yotam Ohayon on 17/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion
@testable import Deluge

class ThemeManagerMock: ThemeManaging {
    
    let trackColor = UIColor(red: 239, green: 239, blue: 244)
    
    func progressColor(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .downloading, .seeding: return UIColor(red: 0, green: 122.0, blue: 255.0)
        case .paused: return UIColor(red: 199.0, green: 199.0, blue: 204.0)
        default: return UIColor(red: 239.0, green: 239.0, blue: 244.0)
        }
    }
    
    func progressNumericColor(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .downloading: return UIColor(red: 0, green: 122.0, blue: 255.0)
        case .paused: return UIColor(red: 178, green: 178, blue: 178)
        default: return .clear
        }
    }
    
    func progressBackgroundColor(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .seeding: return UIColor(red: 0, green: 117.0, blue: 255.0)
        default: return .clear
        }
    }
    
}
