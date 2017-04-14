//
//  CompletedCellViewModelSpec.swift
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

class CompletedCellViewModelSpec: QuickSpec {
    
    let disposeBag = DisposeBag()
    
    override func spec() {
        
        context("nil values") {
            
            it("returns nil") {
                
                let torrent = TorrentMock()
                torrent.name = nil
                torrent.totalSize = nil
                let viewModel: CompletedCellViewModeling = CompletedCellViewModel(torrent: torrent)
                
                expect(viewModel.title).to(beNil())
                expect(viewModel.size).to(beNil())
                
            }
            
        }
        
        context("non-nil values") {
            
            it("returns correct values") {
                
                let torrent = TorrentMock()
                torrent.name = "name"
                torrent.totalSize = 1024
                let viewModel: CompletedCellViewModeling = CompletedCellViewModel(torrent: torrent)
                
                expect(viewModel.title).to(equal("name"))
                expect(viewModel.size).to(equal("1.0 KiB"))
                
            }
            
        }
        
    }

}
