//
//  UIResponder+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 02/12/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIResponder {
    
    var becomeFirstResponder: Binder<Void> {
        return Binder(self.base) { textfield, _ in
            textfield.becomeFirstResponder()
        }
    }
    
    var resignFirstResponder: Binder<Void> {
        return Binder(self.base) { textfield, _ in
            textfield.resignFirstResponder()
        }
    }
    
}
