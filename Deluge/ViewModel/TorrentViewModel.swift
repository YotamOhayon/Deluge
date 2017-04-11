//
//  TorrentViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion
import RxCocoa

protocol TorrentModeling {
    var title: String? { get }
    var downloadSpeed: Driver<String?> { get }
    var progress: Driver<ProgressType> { get }
}

class TorrentModel: TorrentModeling {
    
    let title: String?
    let downloadSpeed: Driver<String?>
    let progress: Driver<ProgressType>
    
    init(torrent: Torrent, delugionService: DelugionServicing) {
        self.title = torrent.name
        
        let info = delugionService.torrentInfo(hash: torrent.torrentHash)
            .filter {
                switch $0 {
                case .valid(_):
                    return true
                default:
                    return false
                }
            }.map {
                return $0.associatedValue as! Torrent
        }
        
        self.downloadSpeed = info.map { String(describing: $0.downloadPayloadrate) }.asDriver(onErrorJustReturn: nil)
        
        self.progress = info.map {
            $0.progressView
        }.asDriver(onErrorJustReturn: .other(#imageLiteral(resourceName: "x")))
        
    }
    
}
