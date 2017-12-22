//
//  AppCoordinator.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let di: DependencyInjector

    init(window: UIWindow, di: DependencyInjector) {
        self.window = window
        self.di = di
    }

    override func start() -> Observable<Void> {
        let repositoryListCoordinator = MainCoordinator(window: window, di: di)
        return coordinate(to: repositoryListCoordinator)
    }
}

class MainCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private let di: DependencyInjector
    
    init(window: UIWindow, di: DependencyInjector) {
        self.window = window
        self.di = di
    }
    
    override func start() -> Observable<CoordinationResult> {
        let storyboard = self.di.storyboard
        window.rootViewController = storyboard.instantiateInitialViewController()
        return Observable.never()
    }
}
