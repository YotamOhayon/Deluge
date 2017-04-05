//
//  SettingsSpec.swift
//  Deluge
//
//  Created by Yotam Ohayon on 26/08/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxBlocking
import RxTest
import RxSwift
import RxCocoa
@testable import Deluge

class SettingsSpec: QuickSpec {
    
    override func spec() {
        
        describe("SettingsServicing") {
            
            var userDefaults: UserDefaults!
            var settings: Settings!
            let bag = DisposeBag()
            
            beforeEach {
                userDefaults = UserDefaults()
                userDefaults.removeObject(forKey: "host")
                userDefaults.removeObject(forKey: "port")
                userDefaults.removeObject(forKey: "password")
                settings = Settings(userDefaults: userDefaults)
            }
            
            describe("host") {
                
                it("starts with nil when there'settings.nothing in user defaults") {
                    
                    let actual = Variable<String?>("some value")
                    settings.host.bind(to: actual).disposed(by: bag)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                }
                
                it("publishes host when it is set") {
                    
                    let actual = Variable<String?>("some value")
                    settings.host.bind(to: actual).disposed(by: bag)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    settings.hostBinder.onNext("host")
                    expect(actual.value).toEventually(equal("host"),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                }
                
                it("publishes can be set back to nil") {
                    
                    let actual = Variable<String?>(nil)
                    settings.host.bind(to: actual).disposed(by: bag)
                    settings.hostBinder.onNext("host")
                    expect(actual.value).toEventually(equal("host"),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    settings.hostBinder.onNext(nil)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    
                }
                
            }
            
            describe("port") {
                
                it("starts with nil when there'settings.nothing in user defaults") {
                    
                    let actual = Variable<Int?>(1)
                    settings.port.bind(to: actual).disposed(by: bag)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                }
                
                it("publishes host when it is set") {
                    
                    let actual = Variable<Int?>(1)
                    settings.port.bind(to: actual).disposed(by: bag)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    settings.portBinder.onNext(80)
                    expect(actual.value).toEventually(equal(80),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                }
                
                it("publishes can be set back to nil") {
                    
                    let actual = Variable<Int?>(nil)
                    settings.port.bind(to: actual).disposed(by: bag)
                    settings.portBinder.onNext(80)
                    expect(actual.value).toEventually(equal(80),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    settings.portBinder.onNext(nil)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    
                }

            }
            
            describe("password") {
                
                it("starts with nil when there'settings.nothing in user defaults") {
                    
                    let actual = Variable<String?>("some value")
                    settings.password.bind(to: actual).disposed(by: bag)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                }
                
                it("publishes host when it is set") {
                    
                    let actual = Variable<String?>("some value")
                    settings.password.bind(to: actual).disposed(by: bag)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    settings.passwordBinder.onNext("host")
                    expect(actual.value).toEventually(equal("host"),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                }
                
                it("publishes can be set back to nil") {
                    
                    let actual = Variable<String?>(nil)
                    settings.password.bind(to: actual).disposed(by: bag)
                    settings.passwordBinder.onNext("host")
                    expect(actual.value).toEventually(equal("host"),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    settings.passwordBinder.onNext(nil)
                    expect(actual.value).toEventually(beNil(),
                                                      timeout: 2.0,
                                                      pollInterval: 0.2,
                                                      description: nil)
                    
                }
                
            }
            
        }
        
    }
    
}
