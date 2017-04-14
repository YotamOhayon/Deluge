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
    var progressNumeric: String? { get }
    var downloadSpeed: String? { get }
    var eta: String? { get }
}

class DownloadingCellViewModel: DownloadingCellViewModeling {
    
    let title: String?
    let progress: Double
    let progressNumeric: String?
    let downloadSpeed: String?
    let eta: String?
    
    init(torrent: TorrentProtocol) {
        self.title = torrent.name
        if let progress = torrent.progress {
            self.progress = Double(3.6 * progress)
            self.progressNumeric = String(describing: progress.setPrecision(to: 0))
        }
        else {
            self.progress = 0
            self.progressNumeric = nil
        }
        if let downloadSpeed = torrent.downloadPayloadrate {
            let (speed, unit) = downloadSpeed.inUnits(withPrecision: 1)
            self.downloadSpeed = "\(speed) \(unit.stringifiedAsSpeed)"
        }
        else {
            self.downloadSpeed = nil
        }
        if let torrentEta = torrent.eta {
            self.eta = (torrentEta > 0) ? torrentEta.asHMS : nil
        }
        else {
            self.eta = nil
        }
    }
}
