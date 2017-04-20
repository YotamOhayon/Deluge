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
import RxSwift
import RxOptional

struct ProgressInfo {
    
    var angle: Double
    var progressColor: UIColor
    var view: UIView
    
}

protocol TorrentModeling {
    
    var title: String? { get }
    var downloadSpeed: Driver<String?> { get }
    var progress: Driver<ProgressInfo?> { get }
    var torrentFilesViewModel: TorrentFilesViewModeling { get }
    var shouldHidePlayPauseButton: Driver<Bool> { get }
    var didRemoveTorrent: Observable<Bool> { get }
    
    func deleteButtonTapped(withData shouldRemoveData: Bool)
    
}

class TorrentModel: TorrentModeling {
    
    let title: String?
    let downloadSpeed: Driver<String?>
    let progress: Driver<ProgressInfo?>
    let shouldHidePlayPauseButton: Driver<Bool>
    let didRemoveTorrentSubject = PublishSubject<Bool>()
    var didRemoveTorrent: Observable<Bool> {
        return self.didRemoveTorrentSubject.asObservable()
    }
    
    let torrent: TorrentProtocol
    let delugion: DelugionServicing
    let disposeBag = DisposeBag()
    
    init(torrent: TorrentProtocol, delugionService: DelugionServicing) {
        
        self.torrent = torrent
        self.delugion = delugionService
        
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
            $0.progressInfo
            }.asDriver(onErrorJustReturn: nil).startWith(torrent.progressInfo)
        
        self.shouldHidePlayPauseButton = info.map { $0.state == .paused || torrent.state == .downloading }
            .asDriver(onErrorJustReturn: false)
            .startWith(torrent.state == .paused || torrent.state == .downloading)
        
    }
    
    var torrentFilesViewModel: TorrentFilesViewModeling {
        return TorrentFilesViewModel(torrentHash: self.torrent.torrentHash, delugionService: self.delugion)
    }
    
    func deleteButtonTapped(withData shouldRemoveData: Bool) {
        self.delugion.removeTorrent(hash: torrent.torrentHash,
                                    withData: shouldRemoveData)
        {
            switch $0 {
            case .valid:
                self.didRemoveTorrentSubject.onNext(true)
            case .error:
                self.didRemoveTorrentSubject.onNext(false)
            }
        }
    }
    
}
