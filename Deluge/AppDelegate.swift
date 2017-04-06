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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate let container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupContainer()
        setupWindow()
        return true
    }

}

fileprivate extension AppDelegate {
    
    func setupContainer() {
        
    }
    
    func setupWindow() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        
        window.rootViewController = storyboard.instantiateInitialViewController()
        
    }
    
}

