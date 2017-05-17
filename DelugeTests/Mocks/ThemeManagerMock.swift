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
    
    func color(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .seeding: return .green
        case .paused: return .lightGray
        case .error: return .red
        case .downloading: return .blue
        case .queued: return .lightGray
        case .checking: return .lightGray
        }
    }
    
}
