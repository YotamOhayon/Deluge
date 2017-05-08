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
    
    init() {
        
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
        
        Observable.combineLatest(hostname, port).map { hostname, port -> Delugion? in
            
            guard let hostname = hostname,
                let port = port,
                let portInt = Int(port) else {
                return nil
            }
            
            do {
                return try Delugion(hostname: hostname, port: portInt)
            }
            catch {
                return nil
            }
            
        }
        
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
