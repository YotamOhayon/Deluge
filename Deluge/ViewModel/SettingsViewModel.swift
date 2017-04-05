//
//  SettingsViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 26/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Delugion

protocol SettingsViewModeling {
    
    // input
    var hostname: AnyObserver<String?> { get }
    var port: AnyObserver<String?> { get }
    var password: AnyObserver<String?> { get }
    
    // ouput
    var initialHostname: Driver<String?> { get }
    var initialPort: Driver<String?> { get }
    var initialPassword: Driver<String?> { get }
    
}

class SettingsViewModel: SettingsViewModeling {
    
    // input
    let hostname: AnyObserver<String?>
    let port: AnyObserver<String?>
    let password: AnyObserver<String?>
    
    // output
    let initialHostname: Driver<String?>
    let initialPort: Driver<String?>
    let initialPassword: Driver<String?>
    
    private let hostnameSubject = PublishSubject<String?>()
    private let portSubject = PublishSubject<String?>()
    private let passwordSubject = PublishSubject<String?>()
    
    private let disposeBag = DisposeBag()
    
    init(settingsModel: SettingsModeling, settingsService: SettingsServicing) {
        
        self.hostname = self.hostnameSubject.asObserver()
        
        self.hostnameSubject
            .bind(to: settingsModel.hostBinder)
            .disposed(by: disposeBag)
        
        self.port = self.portSubject.asObserver()
        
        self.portSubject
            .map { port -> Int? in
                if let port = port {
                    return Int(port)
                }
                return nil
            }
            .bind(to: settingsModel.portBinder)
            .disposed(by: disposeBag)
        
        self.password = self.passwordSubject.asObserver()
        
        self.passwordSubject
            .bind(to: settingsModel.passwordBinder)
            .disposed(by: disposeBag)
        
        self.initialHostname = settingsService
            .host
            .take(1)
            .asDriver(onErrorJustReturn: nil)
        
        self.initialPort = settingsService
            .port
            .map {
                guard let port = $0, port != 0 else {
                    return nil
                }
                return String(describing: port)
            }
            .take(1)
            .asDriver(onErrorJustReturn: nil)
        
        self.initialPassword = settingsService
            .password
            .take(1)
            .asDriver(onErrorJustReturn: nil)
        
    }
    
}
