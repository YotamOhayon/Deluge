//
//  TorrentCellViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 08/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion

protocol TorrentCellViewModeling {
    
    var title: String? { get }
    var titleColor: UIColor { get }
    var subtitle: String? { get }
    var subtitleColor: UIColor { get }
    var torrent: TorrentProtocol { get }
    
}

class TorrentCellViewModel: TorrentCellViewModeling {
    
    static let reuseIdentifier = "TorrentCell"
    
    let title: String?
    let titleColor: UIColor
    let subtitle: String?
    let subtitleColor: UIColor
    let torrent: TorrentProtocol
    
    init(torrent: TorrentProtocol, theme: TorrentCellTheme) {
        
        self.title = torrent.name
        self.titleColor = theme.titleColor
        self.subtitle = substitleText(forTorrent: torrent)
        self.subtitleColor = theme.subtitleColor(forTorrentState: torrent.state)
        self.torrent = torrent
        
    }
}

func substitleText(forTorrent torrent: TorrentProtocol) -> String? {
    switch torrent.state {
    case .downloading:
        let (speed, unit) = torrent.downloadPayloadrate.inUnits(withPrecision: 1)
        var subtitle = "\(speed) \(unit.stringifiedAsSpeed)"
        if let eta = (torrent.eta > 0) ? torrent.eta.asHMS : nil {
            subtitle += ", \(eta)"
        }
        return subtitle
    case .paused: return "Paused"
    case .seeding: return "Done"
    case .error: return "Error"
    default:
        return nil
    }
}
