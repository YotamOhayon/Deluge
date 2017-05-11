//
//  SettingsService.swift
//  Deluge
//
//  Created by Yotam Ohayon on 27/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift

protocol SettingsServicing {
    var hostObservable: Observable<String?> { get }
    var portObservable: Observable<Int?> { get }
    var passwordObservable: Observable<String?> { get }
}

protocol SettingsModeling: class {
    var host: String? { get set }
    var port: Int? { get set }
    var password: String? { get set }
}

class Settings: SettingsModeling, SettingsServicing {
    
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
