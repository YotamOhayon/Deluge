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
    
    var hostnameObservable: Observable<String?> { get }
    var portObservable: Observable<String?> { get }
    var passwordObservable: Observable<String?> { get }
    var hostname: PublishSubject<String?> { get }
    var port: PublishSubject<String?> { get }
    var password: PublishSubject<String?> { get }
    var connectionLabel: Observable<NSAttributedString> { get }
    
    func done()
    
}

class SettingsViewModel: SettingsViewModeling {
    
    let settingsModel: SettingsModeling
    let hostnameObservable: Observable<String?>
    let portObservable: Observable<String?>
    let passwordObservable: Observable<String?>
    let hostname = PublishSubject<String?>()
    let port = PublishSubject<String?>()
    let password = PublishSubject<String?>()
    let connectionLabel: Observable<NSAttributedString>
    let disposeBag = DisposeBag()
    
    var newHost: String?
    var newPort: Int?
    var newPassword: String?
    
    init(settingsModel: SettingsModeling, settingsService: SettingsServicing) {
        
        self.settingsModel = settingsModel
        
        self.hostnameObservable = settingsService.hostObservable
        self.portObservable = settingsService.portObservable.map {
            guard let port = $0 else {
                return ""
            }
            return String(describing: port)
        }
        self.passwordObservable = settingsService.passwordObservable
        
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
        
        hostname.subscribe(onNext: { [unowned self] in
            self.newHost = $0
        }).disposed(by: disposeBag)
        
        port.subscribe(onNext: { [unowned self] in
            guard let p = $0, let port = Int(p) else {
                self.newPort = nil
                return
            }
            self.newPort = port
        }).disposed(by: disposeBag)
        
        password.subscribe(onNext: { [unowned self] in
            self.newPassword = $0
        }).disposed(by: disposeBag)
        
    }
    
    func done() {
        self.settingsModel.host ?= self.newHost
        self.settingsModel.port ?= self.newPort
        self.settingsModel.password ?= self.newPassword
    }
    
}
