//
//  MainViewModelSpec.swift
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
import ReachabilitySwift
@testable import Deluge

class MainViewModelSpec: QuickSpec {
    
    let disposeBag = DisposeBag()
    
    override func spec() {
        
        var delugion: DelugionServiceMock!
        var viewModel: MainViewModeling!
        
        beforeEach {
            delugion = DelugionServiceMock()
            let settings = SettingsMock(userDefaults: UserDefaults.standard)
            viewModel = MainViewModel(delugionService: delugion,
                                      themeManager: ThemeManagerMock(),
                                      reachability: Reachability(),
                                      settings: settings,
                                      textManager: TextManagerMock(),
                                      userDefaults: UserDefaults.standard)
        }
        
        describe("") {
            
            it("") {
                
                delugion.connectionResponse = .valid()
                delugion.torrentsResponse = .valid([TorrentMock()])
                
                var torrents: [TorrentProtocol]? = nil
                viewModel.torrents.drive(onNext: {
                    torrents = $0
                }).disposed(by: self.disposeBag)
                
                expect(torrents).toEventuallyNot(beNil(),
                                                 timeout: 5,
                                                 pollInterval: 0.2,
                                                 description: nil)
                
                expect(torrents?.count).to(equal(1))
                expect(torrents?[0].torrentHash).to(equal(TorrentMock().torrentHash))
                
            }
            
        }
        
        
    }
    
}
