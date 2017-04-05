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
        
        container.register(Settings.self) { r in
            Settings(userDefaults: r.resolve(UserDefaults.self)!)
            }.inObjectScope(.container)
        
        container.register(SettingsServicing.self) { r in
            r.resolve(Settings.self)!
        }
        
        container.register(SettingsModeling.self) { r in
            r.resolve(Settings.self)!
        }
        
        container.register(DelugionServicing.self) { r in
            return DelugionService(settings: r.resolve(SettingsServicing.self)!)
            }.inObjectScope(.container)
        
        container.register(ThemeServicing.self) { _ in
            ThemeService()
        }
        
        container.register(TextManaging.self) { _ in
            TextManager()
        }
        
    }
    
    func registerScreens() {
        
        container.register(MainViewModeling.self) { r in
            MainViewModel(delugionService: r.resolve(DelugionServicing.self)!,
                          themeManager: r.resolve(ThemeServicing.self)!,
                          reachability: r.resolve(Reachability?.self)!,
                          settings: r.resolve(SettingsServicing.self)!,
                          textManager: r.resolve(TextManaging.self)!,
                          userDefaults: r.resolve(UserDefaults.self)!)
        }
        
        container.storyboardInitCompleted(MainViewController.self) { r, c in
            c.themeManager = r.resolve(ThemeServicing.self)
            c.viewModel = r.resolve(MainViewModeling.self)
            c.textManager = r.resolve(TextManaging.self)
        }
        
        container.register(SettingsViewModeling.self) { r in
            return SettingsViewModel(settingsModel: r.resolve(SettingsModeling.self)!,
                                     settingsService: r.resolve(SettingsServicing.self)!)
        }
        
        container.storyboardInitCompleted(SettingsTableViewController.self) { r, c in
            c.viewModel = r.resolve(SettingsViewModeling.self)
        }
        
    }
    
}
