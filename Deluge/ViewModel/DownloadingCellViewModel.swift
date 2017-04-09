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
    
    init(torrent: Torrent) {
        self.title = torrent.name
        self.progress = Double(3.6 * (torrent.progress ?? 0))
        self.progressNumeric = String(describing: (torrent.progress ?? 0).setPrecision(to: 0))
        let (speed, unit) = torrent.downloadPayloadrate?.inUnits() ?? (0, .byte)
        self.downloadSpeed = "\(speed) \(unit.stringifiedAsSpeed)"
        self.eta = torrent.eta == 0 ? "Calculating" : torrent.eta?.asHMS
    }
}
