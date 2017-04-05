//
//  TestObserver.swift
//  Deluge
//
//  Created by Yotam Ohayon on 07/09/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift

class TestObserver<T>: ObserverType {
    
    typealias E = T
    
    var count: Int = 0
    var elements = [T]()
    var value: T
    var completed = false
    var error: Error?
    
    init(_ value: T) {
        self.value = value
    }
    
    func on(_ event: Event<E>) {
        switch event {
        case .next(let element):
            self.value = element
            self.elements.append(element)
            self.count += 1
        case .completed:
            self.completed = true
        case .error(let error):
            self.error = error
        }
    }
    
}
