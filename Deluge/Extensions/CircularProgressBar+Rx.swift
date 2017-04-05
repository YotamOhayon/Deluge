//
//  CircularProgressBar+Rx.swift
//  Deluge
//
//  Created by Yotam Ohayon on 07/12/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Delugion

extension CircularProgressBar {
    
    func setTorrent(_ torrent: TorrentProtocol) {
        self.image = torrent.state == .seeding ? #imageLiteral(resourceName: "Checkmark") : nil
        self.progress = CGFloat(torrent.progress)
        self.showProgress = torrent.state != .seeding
        self.color = self.progressColor(forTorrentState: torrent.state)
    }
    
    private func progressColor(forTorrentState state: TorrentState) -> UIColor {
        switch state {
        case .downloading:
            return UIColor(red: 0, green: 122, blue: 255)
        case .seeding:
            return UIColor(red: 0, green: 117, blue: 255)
        case .error:
            return UIColor(red: 254, green: 56, blue: 36)
        default:
            return UIColor(red: 199, green: 199, blue: 204)
        }
    }
    
}

extension Reactive where Base: CircularProgressBar {
    
    var torrent: Binder<TorrentProtocol> {
        return Binder(self.base) { progressView, torrent in
            progressView.setTorrent(torrent)
        }
    }
    
}
