//
//  AppDelegate.swift
//  Deluge
//
//  Created by Yotam Ohayon on 06/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let dependencyInjector = DependencyInjector()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        setupWindow()
        return true
        
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let vc = self.window?.rootViewController else {
            return false
        }
        
        let addTorrentViewController = self.dependencyInjector.addTorrentViewController(magnetURL: url)
        
        vc.present(addTorrentViewController, animated: false, completion: nil)
        
        return true
        
    }

}

fileprivate extension AppDelegate {
    
    func setupWindow() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        let storyboard = self.dependencyInjector.storyboard
        
        window.rootViewController = storyboard.instantiateInitialViewController()
        
    }
    
}

