//
//  SettingsViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 26/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import Delugion

protocol SettingsViewModeling {
    var hostname: PublishSubject<String?> { get }
    var port: PublishSubject<String?> { get }
    var password: PublishSubject<String?> { get }
    var connectionLabel: Observable<NSAttributedString> { get }
}

class SettingsViewModel: SettingsViewModeling {
    
    let hostname = PublishSubject<String?>()
    let port = PublishSubject<String?>()
    let password = PublishSubject<String?>()
    let connectionLabel: Observable<NSAttributedString>
    let disposeBag = DisposeBag()
    
    init(settingsModel: SettingsModeling) {
        
        self.connectionLabel = Observable.combineLatest(hostname, port, password) {
            ($0, $1, $2)
            }.map { hostname, port, password in
                
                guard hostname.hasCharacters else {
                    return NSAttributedString(string: "missing hostname", attributes: nil)
                }
                guard port.hasCharacters else {
                    return NSAttributedString(string: "invalid port!", attributes: nil)
                }
                guard password.hasCharacters else {
                    return NSAttributedString(string: "missing password", attributes: nil)
                }
                
                return NSAttributedString(string: "GOOD!", attributes: nil)
            }

        let settings = Observable.just(settingsModel)
        
        hostname.withLatestFrom(settings) { $0 }.subscribe(onNext: {
            let host = $0.0
            let settings = $0.1
            settings.host = host
        }).disposed(by: disposeBag)
        
        port.withLatestFrom(settings) { $0 }.subscribe(onNext: {
            let settings = $0.1
            guard let p = $0.0, let port = Int(p) else {
                settings.port = nil
                return
            }
            settings.port = port
        }).disposed(by: disposeBag)
        
        password.withLatestFrom(settings) { $0 }.subscribe(onNext: {
            let password = $0.0
            let settings = $0.1
            settings.password = password
        }).disposed(by: disposeBag)
        
    }
    
}

extension Optional where Wrapped == String {
    var hasCharacters: Bool {
        switch self {
        case .none:
            return false
        case .some(let wrapped):
            return wrapped.characters.count > 0
        }
    }
}
