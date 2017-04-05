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
import RxDataSources
import Reachability

protocol MainViewModeling {
    var isReachable: Driver<Bool> { get }
    var isMissingCredentials: Driver<Bool> { get }
    var shouldShowConnectionManager: Driver<Bool> { get }
    var hosts: Driver<[Host]> { get }
    var selectedHost: PublishSubject<String> { get }
    var isConnected: Driver<Bool> { get }
    var torrents: Driver<[SectionOfTorrents]> { get }
    var noTorrents: Driver<Bool> { get }
    var showActivitySpinnder: Driver<Bool> { get }
    var removeTorrent: PublishSubject<(String, Bool)> { get }
    var resumeTorrent: PublishSubject<String> { get }
    var pauseTorrent: PublishSubject<String> { get }
    var titleView: Driver<TitleView?> { get }
    var shouldUpdateTable: PublishSubject<Bool> { get }
    func viewModel(forTorrent: TorrentProtocol) -> TorrentViewModeling
}

class MainViewModel: MainViewModeling {
    
    private let textManager: TextManaging
    private let disposeBag = DisposeBag()
    private let delugionService: DelugionServicing
    private let themeManager: ThemeServicing
    private let userDefaults: UserDefaults
    private let spinnerSubject = PublishSubject<Bool>()
    
    let isReachable: Driver<Bool>
    let isMissingCredentials: Driver<Bool>
    let shouldShowConnectionManager: Driver<Bool>
    let hosts: Driver<[Host]>
    let selectedHost = PublishSubject<String>()
    let isConnected: Driver<Bool>
    let showActivitySpinnder: Driver<Bool>
    let titleView: Driver<TitleView?>
    let torrents: Driver<[SectionOfTorrents]>
    let noTorrents: Driver<Bool>
    let removeTorrent = PublishSubject<(String, Bool)>()
    let resumeTorrent = PublishSubject<String>()
    let pauseTorrent = PublishSubject<String>()
    let shouldUpdateTable = PublishSubject<Bool>()
    
    init(delugionService: DelugionServicing,
         themeManager: ThemeServicing,
         reachability: Reachability?,
         settings: SettingsServicing,
         textManager: TextManaging,
         userDefaults: UserDefaults) {
        
        self.userDefaults = userDefaults
        self.textManager = textManager
        self.delugionService = delugionService
        self.themeManager = themeManager
        
        self.isReachable = reachability!
            .rx
            .isReachable
            .asDriver(onErrorDriveWith: Driver.never())
        
        let credentials = Observable
            .combineLatest(settings.host,
                           settings.port,
                           settings.password)
            .share(replay: 1, scope: .forever)

        let isMissingCredentials: Observable<Bool> = credentials
            .map { $0.0.isEmpty || $0.1 == nil || $0.2.isEmpty }
        self.isMissingCredentials = isMissingCredentials
            .asDriver(onErrorDriveWith: Driver.never())
        
        let checkSession: Observable<Bool> = isMissingCredentials
            .filter { !$0 }
            .flatMap { _ in
                delugionService.checkSession
            }
            .share(replay: 1, scope: .forever)
        
        // we try to log in when session does not exist
        let login = checkSession
            .filter { !$0 }
            .flatMap { _ in
                delugionService.login
            }

        // we check if we are connected to a certain
        // daemon if session exists or login succeeded
        let connected: Observable<Bool> =
            Observable.merge([checkSession, login])
                .filter { $0 == true }
                .flatMap { _ in
                    delugionService.connected
                }
        
        // if we are not connected, we list daemons
        // and let the user choose one
        let hosts = connected
            .filter { !$0 }
            .flatMapLatest { _ in
            delugionService.hosts
        }
        self.hosts = hosts
            .asDriver(onErrorDriveWith: Driver.never())
        
        // connect to selected daemon
        let connect = self.selectedHost
            .flatMapLatest {
                delugionService.connect(hash: $0)
            }
            .map { true }
            .share(replay: 1, scope: .forever)
        
        let isConnected = Observable<Bool>.merge([connected, connect])
            .filter { $0 == true }
            .share(replay: 1, scope: .forever)
        self.isConnected = isConnected
            .asDriver(onErrorJustReturn: false)
        
        let torrents: Observable<[SectionOfTorrents]> = isConnected
            .filter { $0 }
            .flatMap { _ in
            delugionService.torrents
            }
            .map { torrents in
                return [SectionOfTorrents(header: "", items: torrents)]
            }
            .withLatestFrom(shouldUpdateTable.startWith(true)) { ($0, $1) }
            .filter { $0.1 }.map { $0.0 }
        
        self.torrents = torrents
            .filter { $0[0].items.isNotEmpty }
            .asDriver(onErrorJustReturn: [SectionOfTorrents]())
        
        self.noTorrents = torrents
            .map { $0[0].items.isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)

        let showActivitySpinnder = Observable<Bool>
            .merge([isMissingCredentials.map { _ in  false },
                    connect.map { _ in true },
                    isConnected,
                    self.spinnerSubject,
                    torrents.map { _ in false }])
            .startWith(true)
    
        self.showActivitySpinnder = showActivitySpinnder
            .asDriver(onErrorJustReturn: false)
        
        let shouldShowConnectionManager = Observable<Bool>
            .merge([isMissingCredentials.filter { $0 }.map { _ in false },
                    torrents.map { _ in false },
                    hosts.map { _ in true }])
            .startWith(false)
        self.shouldShowConnectionManager = shouldShowConnectionManager
            .asDriver(onErrorJustReturn: false)
        
        self.removeTorrent
            .map { _ in true }
            .bind(to: spinnerSubject)
            .disposed(by: disposeBag)
        
        self.removeTorrent
            .flatMap {
            delugionService.removeTorrent(hash: $0.0, withData: $0.1)
            }
            .map { _ in true }
            .bind(to: self.shouldUpdateTable)
            .disposed(by: disposeBag)
        
        self.resumeTorrent
            .map { _ in true }
            .bind(to: spinnerSubject)
            .disposed(by: disposeBag)
        
        self.resumeTorrent
            .flatMap {
                delugionService.resumeTorrent(hash: $0)
            }
            .map { _ in true }
            .bind(to: self.shouldUpdateTable)
            .disposed(by: disposeBag)
        
        self.pauseTorrent
            .map { _ in true }
            .bind(to: spinnerSubject)
            .disposed(by: disposeBag)
        
        self.pauseTorrent
            .flatMap {
                delugionService.pauseTorrent(hash: $0)
            }
            .map { _ in true }
            .bind(to: self.shouldUpdateTable)
            .disposed(by: disposeBag)
        
        let noCredentialsTitleView: Observable<TitleView?> = isMissingCredentials
            .filter { $0 }
            .map { _ -> TitleView? in
                let view = TitleView()
                view.title = "Terri"
                view.subtitle = nil
                return view
        }

        let connectionStatusView: Observable<TitleView?> = isConnected.map { isConnected -> TitleView? in
            let view = TitleView()
            view.title = "Terri"
            view.subtitle = isConnected ? "Connected" : "Connecting..."
            return view
        }
        
        self.titleView = Observable<TitleView?>
            .merge([noCredentialsTitleView, connectionStatusView])
            .asDriver(onErrorJustReturn: nil)
        
    }
    
    func viewModel(forTorrent torrent: TorrentProtocol) -> TorrentViewModeling {
        return TorrentViewModel(torrent: torrent,
                                delugionService: self.delugionService,
                                theme: self.themeManager.torrentDetails,
                                textManager: self.textManager)
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

