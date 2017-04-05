//
//  UIView+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 13/10/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UIView {
    
    func strech(toView view: UIView) {
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension Reactive where Base: UIView {
    
    var endEditing: Binder<Bool> {
        return Binder(self.base) { view, force in
            view.endEditing(force)
        }
    }
    
}
