//
//  DownloadingCellViewModelSpec.swift
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

class DownloadingCellViewModelSpec: QuickSpec {
    
    let disposeBag = DisposeBag()
    
    override func spec() {
        
        context("non-nil values") {
            
            it("returns correct values") {
                
                let torrent = TorrentMock()
                torrent.name = "name"
                torrent.progress = 90
                torrent.downloadPayloadrate = 1024
                torrent.eta = 60
                
                let viewModel: DownloadingCellViewModeling = DownloadingCellViewModel(torrent: torrent)
                
                expect(viewModel.title).to(equal("name"))
                expect(viewModel.progress).to(equal(90.0 * 3.6))
                expect(viewModel.progressNumeric).to(equal("90.0"))
                expect(viewModel.downloadSpeed).to(equal("1.0 KiB/s"))
                expect(viewModel.eta).to(equal("1m"))
                
            }
            
        }
        
    }

}
