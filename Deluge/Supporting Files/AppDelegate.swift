//
//  AppDelegate.swift
//  Deluge
//
//  Created by Yotam Ohayon on 06/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import Delugion
import Fabric
import Crashlytics
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var reachability: Reachability?
    var window: UIWindow?
    fileprivate let container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        reachability = Reachability()
        try? reachability?.startNotifier()
        
        setupContainer()
        setupWindow()
        return true
        
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let vc = self.window?.rootViewController else {
            return false
        }
        
        let storyboard = SwinjectStoryboard.create(name: "Main",
                                                   bundle: nil,
                                                   container: container)
        
        let addTorrentViewController = storyboard.instantiateViewController(withIdentifier: "AddTorrentViewController") as! AddTorrentViewController
        
        let delugion = container.resolve(DelugionServicing.self)!
        addTorrentViewController.viewModel = AddTorrentViewModel(magnetURL: url,
                                                                 delugionService: delugion)
        
        vc.present(addTorrentViewController, animated: false, completion: nil)
        
        return true
        
    }

}

fileprivate extension AppDelegate {
    
    func setupContainer() {
        
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
        
        container.register(SettingsViewModeling.self) { r in
            let settingsModel = r.resolve(SettingsModeling.self)!
            let settingsService = r.resolve(SettingsServicing.self)!
            return SettingsViewModel(settingsModel: settingsModel,
                                     settingsService: settingsService)
        }
        
        container.register(ThemeManaging.self) { _ in
            ThemeManager()
        }
        
        container.register(TextManaging.self) { _ in
            TextManager()
        }
        
        container.register(MainViewModeling.self) { r in
            MainViewModel(delugionService: r.resolve(DelugionServicing.self)!,
                          themeManager: r.resolve(ThemeManaging.self)!,
                          reachability: r.resolve(Reachability?.self)!,
                          settings: r.resolve(SettingsServicing.self)!,
                          textManager: r.resolve(TextManaging.self)!)
        }
        
        container.storyboardInitCompleted(MainViewController.self) { r, c in
            c.themeManager = r.resolve(ThemeManaging.self)
            c.viewModel = r.resolve(MainViewModeling.self)
            c.textManager = r.resolve(TextManaging.self)
        }
        
        container.storyboardInitCompleted(SettingsTableViewController.self) { r, c in
            c.viewModel = r.resolve(SettingsViewModeling.self)
        }
        
    }
    
    func setupWindow() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        let storyboard = SwinjectStoryboard.create(name: "Main",
                                                   bundle: nil,
                                                   container: container)
        
        window.rootViewController = storyboard.instantiateInitialViewController()
        
    }
    
}

