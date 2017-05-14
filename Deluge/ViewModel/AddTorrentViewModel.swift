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

protocol AddTorrentViewModeling {
    var title: Observable<String?> { get }
    var addTapped: PublishSubject<Void> { get }
}

class AddTorrentViewModel: AddTorrentViewModeling {
    
    let title: Observable<String?>
    let magnetInfo = BehaviorSubject<MagnetInfo?>(value: nil)
    let addTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init(magnetURL: URL, delugionService: DelugionServicing) {
        
        self.title = self.magnetInfo.map { $0?.name }
        delugionService.getMagnetInfo(url: magnetURL) { response in
            switch response {
            case .error(let error):
                print(error)
            case .valid(let magnetInfo):
                self.magnetInfo.onNext(magnetInfo)
            }
        }
        
        self.addTapped.withLatestFrom(self.magnetInfo) { ($1) }
            .subscribe(onNext: {
                guard let url = $0?.magnetUrl else {
                    return
                }
                delugionService.addTorrent(url: url, completion: {})
        }).disposed(by: self.disposeBag)
        
    }
    
}
