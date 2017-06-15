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
import ReachabilitySwift
import RxReachability
import RxDataSources

typealias filterAlertData = (String?, [TorrentState]?, ((TorrentState) -> Void)?, (() -> Void)?, String?, String?)
typealias sortAlertData = (String?, [SortBy]?, ((SortBy) -> Void)?)

enum ViewToShow {
    case serverNotConfigured, notConnectedToServer, noTorrents
}

protocol MainViewModeling {
    var showError: Driver<ViewToShow?> { get }
    var torrents: Driver<[SectionOfTorrents]> { get }
//    var filterButtonTapped: PublishSubject<Void> { get }
    var isReachable: Observable<Bool> { get }
//    var showFilterAlertController: Driver<filterAlertData> { get }
//    var showSortAlertController: Driver<sortAlertData> { get }
//    var filterStatus: Driver<String?> { get }
//    var sortButtonTapped: PublishSubject<Void> { get }
    func viewModel(forTorrent: TorrentProtocol) -> TorrentViewModeling
}

class MainViewModel: MainViewModeling {
    
    private let textManager: TextManaging
    private let disposeBag = DisposeBag()
    private let delugionService: DelugionServicing
    private let themeManager: ThemeManaging
    private let userDefaults: UserDefaults
    
    let isReachable: Observable<Bool>
    let showError: Driver<ViewToShow?>
    let torrents: Driver<[SectionOfTorrents]>
//    let filterButtonTapped = PublishSubject<Void>()
//    let sortButtonTapped = PublishSubject<Void>()
//    let showFilterAlertController: Driver<filterAlertData>
//    let showSortAlertController: Driver<sortAlertData>
//    let filter: BehaviorSubject<TorrentState?>
//    let sort: BehaviorSubject<SortBy>
//    let filterStatus: Driver<String?>
    
    init(delugionService: DelugionServicing,
         themeManager: ThemeManaging,
         reachability: Reachability?,
         settings: SettingsServicing,
         textManager: TextManaging,
         userDefaults: UserDefaults) {
        
        self.userDefaults = userDefaults
        self.textManager = textManager
        self.delugionService = delugionService
        self.themeManager = themeManager
        
        self.isReachable = reachability!.rx.isReachable
        
        let isMissingCredentials: Observable<Bool> = Observable.combineLatest(settings.hostObservable,
                                                            settings.portObservable,
                                                            settings.passwordObservable)
        {
                                                                ($0, $1, $2)
            }.map {
                let password: Bool = $0.2?.isEmpty ?? true
                return $0.0 == nil || $0.1 == nil || password
        }
        
        let isConnected: Observable<Bool> = delugionService.connection.map {
            switch $0 {
            case .error(_):
                return false
            case .valid():
                return true
            }
        }
        
        self.showError = Observable.combineLatest(isMissingCredentials, isConnected, delugionService.torrents) {
            ($0, $1, $2)
            }.map {
                if $0 {
                    return ViewToShow.serverNotConfigured
                }
                else if !$1 {
                    return ViewToShow.notConnectedToServer
                }
                else if case .valid(let torrents) = $2, torrents.count == 0 {
                    return ViewToShow.noTorrents
                }
                else {
                    return nil
                }
            }.asDriver(onErrorJustReturn: nil)
        
//        let filter = BehaviorSubject<TorrentState?>(value: nil)
//        self.filter = filter
//        
//        let sort = BehaviorSubject<SortBy>(value: SortBy.priority)
//        self.sort = sort
        
        self.torrents = Observable.combineLatest(isMissingCredentials,
                                                 isConnected,
                                                 delugionService.torrents/*,
                                                 filter,
                                                 sort*/) {
                                                    ($0, $1, $2/*, $3, $4*/)
            }.map { isMissingCredentials, isConnected, torrents/*, filter, sort*/ in
                
                guard !isMissingCredentials, isConnected else {
                    return [SectionOfTorrents]()
                }
                
                switch torrents {
                case .error(_):
                    return [SectionOfTorrents]()
                case .valid(var torrentsArray):
                    torrentsArray = torrentsArray.filter { $0.state != .checking }
//                    if let filter = filter {
//                        torrentsArray = torrentsArray.filter { $0.state == filter }
//                    }
//                    torrentsArray = torrentsArray.sorted(by: sort)
                    return [SectionOfTorrents(header: "", items: torrentsArray)]
                }
                
            }
            .asDriver(onErrorJustReturn: [SectionOfTorrents]())
        
//        self.showFilterAlertController = self.filterButtonTapped.map {
//            let message = textManager.filterByTitle
//            let actions: [TorrentState] = [.seeding, .paused, .error, .downloading, .queued, .checking]
//            let block: (TorrentState) -> Void = { filter.onNext($0) }
//            let allBlock: () -> Void = { filter.onNext(nil) }
//            let allTitle = textManager.showAll
//            let cancel = textManager.cancel
//            return (message, actions, block, allBlock, allTitle, cancel)
//            }.asDriver(onErrorJustReturn: (nil, nil, nil, nil, nil, nil))
//        
//        self.filterStatus = filter.map {
//            $0?.rawValue ?? textManager.all
//            }.asDriver(onErrorJustReturn: nil)
//        
//        self.showSortAlertController = self.sortButtonTapped.map {
//            let message = textManager.sortByTitle
//            let actions = SortBy.allValues
//            let block: (SortBy) -> Void = { sort.onNext($0) }
//            return (message, actions, block)
//            }.asDriver(onErrorJustReturn: (nil, nil, nil))
        
    }
    
    func viewModel(forTorrent torrent: TorrentProtocol) -> TorrentViewModeling {
        return TorrentViewModel(torrent: torrent,
                            delugionService: self.delugionService,
                            themeManager: self.themeManager,
                            textManager: self.textManager,
                            userDefaults: self.userDefaults)
    }
    
}

struct SectionOfTorrents {
    var header: String
    var items: [Item]
}

extension SectionOfTorrents: SectionModelType {
    typealias Item = TorrentProtocol
    
    init(original: SectionOfTorrents, items: [Item]) {
        self = original
        self.items = items
    }
}
