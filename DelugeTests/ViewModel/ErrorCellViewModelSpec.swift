//
//  ErrorCellViewModelSpec.swift
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

class ErrorCellViewModelSpec: QuickSpec {
    
    let disposeBag = DisposeBag()
    
    override func spec() {
        
        context("nil values") {
            
            it("returns nil") {
                
                let torrent = TorrentMock()
                torrent.name = nil
                torrent.progress = nil
                torrent.downloadPayloadrate = nil
                torrent.eta = nil
                
                let viewModel: ErrorCellViewModeling = ErrorCellViewModel(torrent: torrent)
                
                expect(viewModel.title).to(beNil())
                
            }
            
        }
        
        context("non-nil values") {
            
            it("returns correct values") {
                
                let torrent = TorrentMock()
                torrent.name = "name"
                
                let viewModel: ErrorCellViewModeling = ErrorCellViewModel(torrent: torrent)
                
                expect(viewModel.title).to(equal("name"))
                
            }
            
        }
        
    }

}
