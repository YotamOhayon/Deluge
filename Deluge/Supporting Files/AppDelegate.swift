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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate let container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        setupContainer()
        setupWindow()
        return true
    }

}

fileprivate extension AppDelegate {
    
    func setupContainer() {
        
        container.register(DelugionServicing.self) { _ in
            let delugion = try! Delugion(hostname: "yotamoo.zapto.org", port: 8112)
            return DelugionService(delugion: delugion)
        }.inObjectScope(.container)
        
        container.register(SettingsViewModeling.self) { _ in
            SettingsViewModel()
        }
        
        container.register(MainViewModeling.self) { r in
            MainViewModel(delugionService: r.resolve(DelugionServicing.self)!)
        }
        
        container.storyboardInitCompleted(MainViewController.self) { r, c in
            c.viewModel = r.resolve(MainViewModeling.self)
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

