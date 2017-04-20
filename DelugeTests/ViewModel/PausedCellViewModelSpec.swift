//
//  PausedCellViewModelSpec.swift
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

class PausedCellViewModelSpec: QuickSpec {
    
    let disposeBag = DisposeBag()
    
    override func spec() {
        
        context("non-nil values") {
            
            it("returns correct values") {
                
                let torrent = TorrentMock()
                torrent.name = "name"
                torrent.progress = 50
                
                let viewModel: PausedCellViewModeling = PausedCellViewModel(torrent: torrent)
                
                expect(viewModel.title).to(equal("name"))
                expect(viewModel.progress).to(equal(50 * 3.6))
                expect(viewModel.progressNumeric).to(equal("50.0"))
                
            }
            
        }
        
    }

}
