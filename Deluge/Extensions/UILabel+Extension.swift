//
//  UILabel+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 03/12/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    
    var color: Binder<UIColor?> {
        return Binder(self.base) { label, color in
            label.textColor = color
        }
    }
    
}
