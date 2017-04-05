//
//  SettingsMock.swift
//  Deluge
//
//  Created by Yotam Ohayon on 20/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import Deluge

class SettingsMock: SettingsModeling, SettingsServicing {
    
    // SettingsServicing
    var host: Observable<String?>
    var port: Observable<Int?>
    var password: Observable<String?>
    
    // SettingsModeling
    lazy var hostBinder: Binder<String?> = {
        return Binder(self) { settingsMock, value in
            settingsMock.hostSubject.onNext(value)
        }
    }()
    
    lazy var portBinder: Binder<Int?> = {
        Binder(self) { settingsMock, value in
            settingsMock.portSubject.onNext(value)
        }
    }()
    
    lazy var passwordBinder: Binder<String?> = {
        Binder(self) { settingsMock, value in
            settingsMock.passwordSubject.onNext(value)
        }
    }()
    
    private let hostSubject = PublishSubject<String?>()
    private let portSubject = PublishSubject<Int?>()
    private let passwordSubject = PublishSubject<String?>()
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        self.host = hostSubject.asObservable()
        self.port = portSubject.asObservable()
        self.password = passwordSubject.asObservable()
        
    }
    
    
}
