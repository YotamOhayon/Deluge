//
//  MainViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 06/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion
import RxSwift
import RxCocoa

typealias filterAlertData = (String?, [TorrentState]?, ((TorrentState) -> Void)?, (() -> Void)?)

protocol MainViewModeling {
    var torrents: Driver<[TorrentProtocol]> { get }
    var filterButtonTapped: PublishSubject<Void> { get }
    var showFilterAlertController: Driver<filterAlertData> { get }
    var filterStatus: Driver<String?> { get }
    func viewModel(forTorrent: TorrentProtocol) -> TorrentModeling
}

class MainViewModel: MainViewModeling {
    
    let disposeBag = DisposeBag()
    let delugionService: DelugionServicing
    let connected: Observable<ServerResponse<Void>>
    let torrents: Driver<[TorrentProtocol]>
    let filterButtonTapped = PublishSubject<Void>()
    let showFilterAlertController: Driver<filterAlertData>
    let filter: BehaviorSubject<TorrentState?>
    let filterStatus: Driver<String?>
    
    init(delugionService: DelugionServicing) {
        
        self.delugionService = delugionService
        
        self.connected = delugionService.connection.filter {
            switch $0 {
            case .valid:
                return true
            default:
                return false
            }
        }
        
        let filter = BehaviorSubject<TorrentState?>(value: nil)
        self.filter = filter
        
        self.torrents = Observable.combineLatest(connected, delugionService.torrents, filter) {
            ($1, $2)
            }.filter {
                switch $0.0 {
                case .error:
                    return false
                default:
                    return true
                }
            }.map {
                ($0.associatedValue as! [TorrentProtocol], $1)
            }.map { torrents, filter in
                var torrents = torrents.filter { $0.state != .checking }
                if let filter = filter {
                    torrents = torrents.filter { $0.state == filter }
                }
                return torrents
            }
            .asDriver(onErrorJustReturn: [TorrentProtocol]())
        
        self.showFilterAlertController = self.filterButtonTapped.map {
            let message = "Filter by"
            let actions: [TorrentState] = [.seeding, .paused, .error, .downloading, .queued, .checking]
            let block: (TorrentState) -> Void = { filter.onNext($0) }
            let allBlock: () -> Void = { filter.onNext(nil) }
            return (message, actions, block, allBlock)
            }.asDriver(onErrorJustReturn: (nil, nil, nil, nil))
        
        self.filterStatus = filter.map {
            $0?.rawValue ?? "All"
        }.asDriver(onErrorJustReturn: nil)
        
    }
    
    func viewModel(forTorrent torrent: TorrentProtocol) -> TorrentModeling {
        return TorrentModel(torrent: torrent, delugionService: self.delugionService)
    }
    
}
