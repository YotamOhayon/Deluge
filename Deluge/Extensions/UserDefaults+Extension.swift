//
//  UserDefaults+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 02/12/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UserDefaults {
    
    func binder(forKey key: String) -> Binder<String?> {
        return Binder(self.base) { userDefaults, value in
            userDefaults.set(value, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    func binder(forKey key: String) -> Binder<Int?> {
        return Binder(self.base) { userDefaults, value in
            userDefaults.set(value, forKey: key)
            userDefaults.synchronize()
        }
    }
    
}
