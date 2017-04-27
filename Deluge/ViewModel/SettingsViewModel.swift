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
                
                guard let hostname = hostname else {
                    return NSAttributedString(string: "missing hostname", attributes: nil)
                }
                guard let p = port, let port = Int(p) else {
                    return NSAttributedString(string: "invalid port!", attributes: nil)
                }
                guard let password = password else {
                    return NSAttributedString(string: "missing password", attributes: nil)
                }
                do {
//                    let delugion = try Delugion(hostname: hostname, port: port)
//                    delugion.connect(withPassword: password) {
//                        switch $0 {
//                        case .error(let error):
//                            
//                        }
//                    }
                }
                catch {
                    return NSAttributedString(string: "Could not connect", attributes: nil)
                }
                
                return NSAttributedString(string: "GOOD!", attributes: nil)
        }.startWith(NSAttributedString(string: "GOOD!", attributes: nil))
        
    }
    
}
