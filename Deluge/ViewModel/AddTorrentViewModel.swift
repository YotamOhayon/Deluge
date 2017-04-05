//
//  AddTorrentViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 14/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion
import RxSwift
import RxCocoa
import SwiftyBeaver

protocol AddTorrentViewModeling {
    var title: Driver<String?> { get }
    var addTapped: PublishSubject<Void> { get }
    var torrentAdded: Driver<Void> { get }
    var failedAddingTorrent: Driver<Void> { get }
    var spinnerActivity: Driver<Bool> { get }
}

class AddTorrentViewModel: AddTorrentViewModeling {
    
    let title: Driver<String?>
    let addTapped = PublishSubject<Void>()
    let torrentAdded: Driver<Void>
    let failedAddingTorrent: Driver<Void>
    let spinnerActivity: Driver<Bool>
    
    private let magnetInfo = PublishSubject<MagnetInfo?>()
    private let disposeBag = DisposeBag()
    private let log = SwiftyBeaver.self
    
    init(magnetURL: URL, delugionService: DelugionServicing) {
        
        delugionService
            .getMagnetInfo(url: magnetURL)
            .bind(to: self.magnetInfo)
            .disposed(by: self.disposeBag)
        
        self.title = self.magnetInfo
            .map { $0?.name }
            .asDriver(onErrorJustReturn: nil)
        
        self.spinnerActivity = self.magnetInfo
            .map { _ in false }
            .startWith(true)
            .asDriver(onErrorDriveWith: Driver.never())
        
        let didAdd = self.addTapped.withLatestFrom(self.magnetInfo.asObservable())
            .map { $0?.magnetUrl }
            .filterNil()
            .flatMapLatest { url in
                delugionService.addTorrent(url: url)
        }
        
        self.torrentAdded = didAdd
            .filter { $0 }
            .map { _ in () }
            .asDriver(onErrorDriveWith: Driver.never())
        
        self.failedAddingTorrent = didAdd
            .filter { !$0 }
            .map { _ in () }
            .asDriver(onErrorDriveWith: Driver.never())
        
    }
    
}
