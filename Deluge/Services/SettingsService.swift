//
//  SettingsService.swift
//  Deluge
//
//  Created by Yotam Ohayon on 27/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingsServicing {
    
    // output
    var host: Observable<String?> { get }
    var port: Observable<Int?> { get }
    var password: Observable<String?> { get }
    
}

protocol SettingsModeling {
    
    // input
    var hostBinder: Binder<String?> { get }
    var portBinder: Binder<Int?> { get }
    var passwordBinder: Binder<String?> { get }
    
}

class Settings: SettingsModeling, SettingsServicing {
    
    let host: Observable<String?>
    let port: Observable<Int?>
    let password: Observable<String?>
    
    let hostBinder: Binder<String?>
    let portBinder: Binder<Int?>
    let passwordBinder: Binder<String?>
    
    private let bag = DisposeBag()
    
    init(userDefaults: UserDefaults) {
        
        self.host = userDefaults
            .rx
            .observe(String.self, Keys.host.rawValue)
        
        self.hostBinder = userDefaults
            .rx
            .binder(forKey: Keys.host.rawValue)
        
        self.port = userDefaults
            .rx
            .observe(Int.self, Keys.port.rawValue)
        
        self.portBinder = userDefaults
            .rx
            .binder(forKey: Keys.port.rawValue)
        
        self.password = userDefaults
            .rx
            .observe(String.self, Keys.password.rawValue)
        
        self.passwordBinder = userDefaults
            .rx
            .binder(forKey: Keys.password.rawValue)
        
    }
    
    
}

fileprivate enum Keys: String {
    case host, port, password
}
