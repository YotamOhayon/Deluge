//
//  DependencyInjector.swift
//  Deluge
//
//  Created by Yotam Ohayon on 06/12/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Reachability
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

class DependencyInjector {
    
    private let reachability: Reachability?
    private let container = Container()
    
    lazy var storyboard: SwinjectStoryboard = {
        return  SwinjectStoryboard.create(name: "Main",
                                          bundle: nil,
                                          container: self.container)
    }()
    
    init() {
        self.reachability = Reachability()
        try? reachability?.startNotifier()
        registerServices()
        registerScreens()
    }
    
    func addTorrentViewController(magnetURL url: URL) -> AddTorrentViewController {
        
        let addTorrentViewController =
            self.storyboard.instantiateViewController(withIdentifier: "AddTorrentViewController")
                as! AddTorrentViewController
        
        let delugion = self.container.resolve(DelugionServicing.self)!
        addTorrentViewController.viewModel = AddTorrentViewModel(magnetURL: url,
                                                                 delugionService: delugion)
        
        return addTorrentViewController
    }
    
}

private extension DependencyInjector {
    
    func registerServices() {
        
        container.register(Reachability?.self) { [weak self] _ in
            self?.reachability
            }.inObjectScope(.container)
        
        container.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }
        
        container
            .autoregister(Settings.self, initializer: Settings.init)
            .inObjectScope(.container)
        
        container.register(SettingsServicing.self) { r in
            r.resolve(Settings.self)!
        }
        
        container.register(SettingsModeling.self) { r in
            r.resolve(Settings.self)!
        }
        
        container
            .autoregister(DelugionServicing.self, initializer: DelugionService.init)
            .inObjectScope(.container)

        container.autoregister(ThemeServicing.self, initializer: ThemeService.init)
        
        container.autoregister(TextManaging.self, initializer: TextManager.init)
        
    }
    
    func registerScreens() {
        
        container.autoregister(MainViewModeling.self, initializer: MainViewModel.init)
        
        container.storyboardInitCompleted(MainViewController.self) { r, c in
            c.themeManager = r.resolve(ThemeServicing.self)
            c.viewModel = r.resolve(MainViewModeling.self)
            c.textManager = r.resolve(TextManaging.self)
        }
        
        container.autoregister(SettingsViewModeling.self,
                               initializer: SettingsViewModel.init)
        
        container.storyboardInitCompleted(SettingsTableViewController.self) { r, c in
            c.viewModel = r.resolve(SettingsViewModeling.self)
        }
        
    }
    
}
