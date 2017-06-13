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
    var service: Observable<ThemeManaging> { get }
}

class ThemeService: ThemeServicing {
    
    let service: Observable<ThemeManaging>
    
    init(themeManager: ThemeManaging) {
        self.service = Observable.just(themeManager)
    }
    
}

protocol ThemeManaging {
    
    var trackColor: UIColor { get }
    func progressColor(forTorrentState state: TorrentState) -> UIColor
    func progressNumericColor(forTorrentState state: TorrentState) -> UIColor
    func progressBackgroundColor(forTorrentState state: TorrentState) -> UIColor
    
}

class ThemeManager: ThemeManaging {
    
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

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
