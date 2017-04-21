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
    var didRemoveTorrentSubject: PublishSubject<Bool> { get }
    var didRemoveTorrentTapped: PublishSubject<Void> { get }
    var didTapPlayPauseButton: PublishSubject<Void> { get }
    
}

class TorrentModel: TorrentModeling {
    
    let title: String?
    let downloadSpeed: Driver<String?>
    let progress: Driver<ProgressInfo?>
    let shouldHidePlayPauseButton: Driver<Bool>
    let didRemoveTorrentSubject = PublishSubject<Bool>()
    let didRemoveTorrentTapped = PublishSubject<Void>()
    let didTapPlayPauseButton = PublishSubject<Void>()
    
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
        
        self.didTapPlayPauseButton.withLatestFrom(info) {
            $1
            }.subscribe(onNext: { [unowned self] in
                switch $0.state {
                case .downloading:
                    self.delugion.pauseTorrent(hash: $0.torrentHash)
                case .paused:
                    self.delugion.resumeTorrent(hash: $0.torrentHash)
                default:
                    return
                }
            }).disposed(by: disposeBag)
        
        self.didRemoveTorrentTapped.withLatestFrom(info) {
            $1
            }.subscribe(onNext: { [unowned self] in
                self.delugion.removeTorrent(hash: $0.torrentHash,
                                            withData: true)
                {
                    switch $0 {
                    case .valid:
                        self.didRemoveTorrentSubject.onNext(true)
                    case .error:
                        self.didRemoveTorrentSubject.onNext(false)
                    }
                }
            }).disposed(by: disposeBag)
        
    }
    
    var torrentFilesViewModel: TorrentFilesViewModeling {
        return TorrentFilesViewModel(torrentHash: self.torrent.torrentHash, delugionService: self.delugion)
    }
    
}
