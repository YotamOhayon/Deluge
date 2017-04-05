//
//  TorrentCellViewModelSpec.swift
//  Deluge
//
//  Created by Yotam Ohayon on 14/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import Delugion
@testable import Deluge

class TorrentCellViewModelSpec: QuickSpec {
    
    let disposeBag = DisposeBag()
    
    override func spec() {
        
        context("non-nil values") {
            
            it("returns correct values") {
                
                let torrent = TorrentMock()
                torrent.name = "name"
                torrent.progress = 90
                torrent.downloadPayloadrate = 1024
                torrent.eta = 60
                
                let viewModel: TorrentCellViewModeling = TorrentCellViewModel(torrent: torrent,
                                                                              theme: ThemeService().torrentCell)
                
                expect(viewModel.title).to(equal("name"))
                
            }
            
        }
        
    }

}
