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
import UIKit

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
    var didRemoveTorrent: Observable<Bool> { get }
    var showDeleteConfirmation: Observable<(String, String, String, String)> { get }
    var didRemoveTorrentTapped: PublishSubject<Void> { get }
    var didResumeTorrentTapped: PublishSubject<Void> { get }
    var didPauseTorrentTapped: PublishSubject<Void> { get }
    var didPauseTorrent: Observable<Void> { get }
    var didResumeTorrent: Observable<Void> { get }
    var barButtonItems: Driver<UIBarButtonSystemItem> { get }
    
    func removeTorrent(withData shouldRemoveData: Bool)
    
}

class TorrentModel: TorrentModeling {
    
    let title: String?
    let downloadSpeed: Driver<String?>
    let progress: Driver<ProgressInfo?>
    let didRemoveTorrentSubject = PublishSubject<Bool>()
    var didRemoveTorrent: Observable<Bool> {
        return self.didRemoveTorrentSubject.asObservable()
    }
    
    let showDeleteConfirmation: Observable<(String, String, String, String)>
    let didRemoveTorrentTapped = PublishSubject<Void>()
    let didResumeTorrentTapped = PublishSubject<Void>()
    let didPauseTorrentTapped = PublishSubject<Void>()
    
    let didPauseTorrentSubject = PublishSubject<Void>()
    var didPauseTorrent: Observable<Void> {
        return self.didPauseTorrentSubject.asObservable()
    }
    let didResumeTorrentSubject = PublishSubject<Void>()
    var didResumeTorrent: Observable<Void> {
        return self.didResumeTorrentSubject.asObservable()
    }
    let barButtonItems: Driver<UIBarButtonSystemItem>
    
    fileprivate let torrent: TorrentProtocol
    fileprivate let delugion: DelugionServicing
    fileprivate let disposeBag = DisposeBag()
    
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
        
        self.barButtonItems = info
            .map { $0.state }
            .distinctUntilChanged()
            .map { state -> UIBarButtonSystemItem in
                return TorrentFilesViewModel.button(forState: state)
        }.asDriver(onErrorJustReturn: UIBarButtonSystemItem.fixedSpace)
            .startWith(TorrentFilesViewModel.button(forState: torrent.state))
        
        self.downloadSpeed = info.map { String(describing: $0.downloadPayloadrate) }.asDriver(onErrorJustReturn: nil)
        
        self.progress = info.map {
            $0.progressInfo
            }.asDriver(onErrorJustReturn: nil).startWith(torrent.progressInfo)
        
        self.showDeleteConfirmation = didRemoveTorrentTapped.map {
            return ("are you sure", "with data", "without data", "no")
        }
        
        self.didResumeTorrentTapped.withLatestFrom(info) {
            $1
            }.subscribe(onNext: { [unowned self] in
                
                guard $0.state == .paused else {
                    return
                }
                self.delugion.resumeTorrent(hash: $0.torrentHash) {
                    self.didResumeTorrentSubject.onNext()
                }
                
            }).disposed(by: disposeBag)
        
        self.didPauseTorrentTapped.withLatestFrom(info) {
            $1
            }.subscribe(onNext: { [unowned self] in
                
                guard $0.state == .downloading else {
                    return
                }
                self.delugion.pauseTorrent(hash: $0.torrentHash) {
                    self.didPauseTorrentSubject.onNext()
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    var torrentFilesViewModel: TorrentFilesViewModeling {
        return TorrentFilesViewModel(torrentHash: self.torrent.torrentHash, delugionService: self.delugion)
    }
    
    func removeTorrent(withData shouldRemoveData: Bool) {
        self.delugion.removeTorrent(hash: self.torrent.torrentHash,
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

fileprivate extension TorrentFilesViewModel {
    
    class func button(forState state: TorrentState) -> UIBarButtonSystemItem {
        switch state {
        case .downloading:
            return UIBarButtonSystemItem.pause
        case .paused:
            return UIBarButtonSystemItem.play
        default:
            return UIBarButtonSystemItem.fixedSpace
        }
    }
    
}
