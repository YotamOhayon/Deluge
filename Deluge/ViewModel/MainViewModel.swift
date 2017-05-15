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

extension Array where Element == TorrentProtocol {
    
    func sorted(by sortBy: SortBy) -> [Element] {
        switch sortBy {
        case .priority:
            return self.sorted(by: { $0.0.queue > $0.1.queue })
        case .downloadSpeed:
            return self.sorted(by: { $0.0.downloadPayloadrate > $0.1.downloadPayloadrate })
        case .uploadSpeed:
            return self.sorted(by: { $0.0.uploadPayloadrate > $0.1.uploadPayloadrate })
        }
    }
    
}

enum SortBy: Int, CustomStringConvertible {
    
    case priority, downloadSpeed, uploadSpeed
    
    var description: String {
        switch self {
        case .priority:
            return "Priority"
        case .downloadSpeed:
            return "Download Speed"
        case .uploadSpeed:
            return "Upload Speed"
        }
    }
    
    static var allValues: [SortBy] {
        var values = [SortBy]()
        var i = 0
        while let newVal = SortBy(rawValue: i) {
            values.append(newVal)
            i += 1
        }
        return values
    }
    
}

typealias filterAlertData = (String?, [TorrentState]?, ((TorrentState) -> Void)?, (() -> Void)?)
typealias sortAlertData = (String?, [SortBy]?, ((SortBy) -> Void)?)

protocol MainViewModeling {
    var torrents: Driver<[TorrentProtocol]> { get }
    var filterButtonTapped: PublishSubject<Void> { get }
    var showFilterAlertController: Driver<filterAlertData> { get }
    var showSortAlertController: Driver<sortAlertData> { get }
    var filterStatus: Driver<String?> { get }
    var sortButtonTapped: PublishSubject<Void> { get }
    func viewModel(forTorrent: TorrentProtocol) -> TorrentModeling
}

class MainViewModel: MainViewModeling {
    
    let disposeBag = DisposeBag()
    let delugionService: DelugionServicing
    let connected: Observable<ServerResponse<Void>>
    let torrents: Driver<[TorrentProtocol]>
    let filterButtonTapped = PublishSubject<Void>()
    let sortButtonTapped = PublishSubject<Void>()
    let showFilterAlertController: Driver<filterAlertData>
    let showSortAlertController: Driver<sortAlertData>
    let filter: BehaviorSubject<TorrentState?>
    let sort: BehaviorSubject<SortBy>
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
        
        let sort = BehaviorSubject<SortBy>(value: SortBy.downloadSpeed)
        self.sort = sort
        
        self.torrents = Observable.combineLatest(connected, delugionService.torrents, filter, sort) {
            ($1, $2, $3)
            }.filter {
                switch $0.0 {
                case .error:
                    return false
                default:
                    return true
                }
            }.map {
                ($0.associatedValue as! [TorrentProtocol], $1, $2)
            }.map { torrents, filter, sort in
                var torrents = torrents.filter { $0.state != .checking }
                if let filter = filter {
                    torrents = torrents.filter { $0.state == filter }
                }
                torrents = torrents.sorted(by: sort)
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
        
        self.showSortAlertController = self.sortButtonTapped.map {
            let message = "Sort by"
            let actions = SortBy.allValues
            let block: (SortBy) -> Void = { sort.onNext($0) }
            return (message, actions, block)
        }.asDriver(onErrorJustReturn: (nil, nil, nil))
        
    }
    
    func viewModel(forTorrent torrent: TorrentProtocol) -> TorrentModeling {
        return TorrentModel(torrent: torrent, delugionService: self.delugionService)
    }
    
}
