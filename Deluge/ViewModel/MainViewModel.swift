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

protocol MainViewModeling {
    var torrents: Driver<[Torrent]> { get }
    func viewModel(forTorrent: Torrent) -> TorrentModeling
}

class MainViewModel: MainViewModeling {
    
    let disposeBag = DisposeBag()
    
    let torrents: Driver<[Torrent]>
    let delugionService: DelugionServicing
    
    init(delugionService: DelugionServicing) {
        
        self.delugionService = delugionService
        
        delugionService.connection.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        let connected = delugionService.connection.filter {
            switch $0 {
            case .valid(let val):
                return val
            default:
                return false
            }
        }
        
        self.torrents =  Observable.combineLatest(connected, delugionService.torrents) {
            ($1)
            }.filter {
                switch $0 {
                case .error:
                    return false
                default:
                    return true
                }
            }.map {
                $0.associatedValue as! [Torrent]
        }.asDriver(onErrorJustReturn: [Torrent]())
        
    }
    
    func viewModel(forTorrent torrent: Torrent) -> TorrentModeling {
        return TorrentModel(torrent: torrent, delugionService: self.delugionService)
    }
    
}
