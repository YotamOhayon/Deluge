//
//  DelugionServiceSpec.swift
//  Deluge
//
//  Created by Yotam Ohayon on 07/09/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Quick
import RxTest
import Nimble
import RxSwift
import RxCocoa
import Delugion
import OHHTTPStubs
@testable import Deluge

class DelugionServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("DelugionService") {
            
            var settings: SettingsMock!
            var delugionService: Deluge.DelugionService!
            let bag = DisposeBag()
            
            beforeEach {
                settings = SettingsMock(userDefaults: UserDefaults.standard)
                delugionService = DelugionService(settings: settings)
            }
            
            afterEach {
                OHHTTPStubs.removeAllStubs()
            }
            
            describe("delugion") {
                
                it("creates and instane for every non-null change in host or port") {
                    
                    let actual = TestObserver<Delugion?>(nil)
                    delugionService.delugion.bind(to: actual).disposed(by: bag)
                    
                    let host = "yotamoo.zapto.org"
                    let port = 8112
                    
                    settings.hostBinder.onNext(host)
                    expect(actual.value).toEventually(beNil())
                    expect(actual.count).to(equal(0))
                    
                    settings.portBinder.onNext(port)
                    expect(actual.value).toEventuallyNot(beNil())
                    expect(actual.count).to(equal(1))
                    
                    settings.hostBinder.onNext(nil)
                    expect(actual.count).to(equal(1))
                    
                    settings.portBinder.onNext(nil)
                    expect(actual.count).to(equal(1))
                    
                }
                
            }
            /*
            describe("connect") {
                
                it("tries to connect") {
                    
                    let actual = TestObserver<Void>(())
                    delugionService
                        .connect(hash: "sadf")
                        .bind(to: actual)
                        .disposed(by: bag)
                    
                    stub(condition: hasMethodLogin()) { _ in
                        return fixture(fileName: "AutoLoginValid.json")
                    }
                    
                    let host = "some.server.host"
                    let port = 8112
                    let password = "password"
                    
                    settings.hostObserver.onNext(host)
                    settings.portObserver.onNext(port)
                    expect(actual.count).toEventually(equal(0))
                    settings.passwordObserver.onNext(password)
                    expect(actual.count).toEventually(equal(1))
                    
                }
                
            }
  */

            describe("torrents") {
                
//                it("") {
//                    
//                    let actual = TestableObserver<ServerResponse<[TorrentProtocol]>?>()
//                    delugionService.torrents.take(1).bind(to: actual).disposed(by: bag)
//                    
//                    stub(condition: hasMethodLogin()) { _ in
//                        return fixture(fileName: "AutoLoginValid.json")
//                    }
//                    
//                    stub(condition: hasMethodUpdateUI()) { _ in
//                        return fixture(fileName: "TorrentInfo.json")
//                    }
//                    
//                    let host = "yotamoo.zapto.org"
//                    let port = 8112
//                    let password = "password"
//                    
//                    settings.hostObserver.onNext(host)
//                    settings.portObserver.onNext(port)
//                    settings.passwordObserver.onNext(password)
//                    expect(actual.count).toEventually(equal(1),
//                                                      timeout: 2,
//                                                      pollInterval: 0.1,
//                                                      description: nil)
//                    expect(actual.value).toEventuallyNot(beNil(),
//                                                         timeout: 2,
//                                                         pollInterval: 0.1,
//                                                         description: nil)
//                    
//                    guard case .valid(let torrents) = actual.value! else {
//                        fail()
//                        return
//                    }
//                    
//                    expect(torrents.count).to(equal(1))
//                    
//                }
                
            }
            
        }
        
    }
    
}

func fixture(fileName: String) -> OHHTTPStubsResponse {
    let stubPath = OHPathForFile(fileName, type(of: DelugionServiceSpec().self))
    return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
}

func hasMethodLogin() -> OHHTTPStubsTestBlock {
    return hasMethodNamed("auth.login")
}

func hasMethodUpdateUI() -> OHHTTPStubsTestBlock {
    return hasMethodNamed("web.update_ui")
}

func hasMethodNamed(_ methodName: String) -> OHHTTPStubsTestBlock {
    
    return isPath("/json") && { request -> Bool in
        
        guard let data = (request as NSURLRequest).ohhttpStubs_HTTPBody(),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let dict = json as? [String : Any],
            let method = dict["method"] as? String else
        {
            return false
        }
        
        return method == methodName
        
    }
    
}
