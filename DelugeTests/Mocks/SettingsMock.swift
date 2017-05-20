//
//  SettingsMock.swift
//  Deluge
//
//  Created by Yotam Ohayon on 20/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
@testable import Deluge

class SettingsMock: SettingsModeling, SettingsServicing {
    
    let hostObservable: Observable<String?>
    let portObservable: Observable<Int?>
    let passwordObservable: Observable<String?>
    
    var port: Int? {
        get { return userDefaults.integer(forKey: "port") }
        set {
            userDefaults.set(newValue, forKey: "port")
            userDefaults.synchronize()
        }
    }
    
    var host: String? {
        get { return userDefaults.string(forKey: "host") }
        set {
            userDefaults.set(newValue, forKey: "host")
            userDefaults.synchronize()
        }
    }
    
    var password: String? {
        get { return userDefaults.string(forKey: "password") }
        set {
            userDefaults.set(newValue, forKey: "password")
            userDefaults.synchronize()
        }
    }
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.hostObservable = userDefaults.rx.observe(String.self, "host")
        self.portObservable = userDefaults.rx.observe(Int.self, "port")
        self.passwordObservable = userDefaults.rx.observe(String.self, "password")
    }
    
    
}
