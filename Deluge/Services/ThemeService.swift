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
    
    func color(forTorrentState state: TorrentState) -> UIColor
    
}

class ThemeManager: ThemeManaging/*, ThemeServicing*/ {

    func color(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .seeding: return UIColor(red: 0.194, green: 0.84, blue: 0.47, alpha: 1)
        case .paused: return UIColor(red: 0.153, green: 0.153, blue: 0.153, alpha: 1)
        case .error: return UIColor(red: 0.97, green: 0.193, blue: 0.27, alpha: 1)
        case .downloading: return UIColor(red: 0.101, green: 0.161, blue: 0.216, alpha: 1)
        case .queued: return UIColor(red: 0.153, green: 0.153, blue: 0.153, alpha: 1)
        case .checking: return UIColor(red: 0.153, green: 0.153, blue: 0.153, alpha: 1)
        }
    }
    
}
