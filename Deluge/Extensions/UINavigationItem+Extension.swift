//
//  UINavigationItem+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 13/10/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UINavigationItem {
    
    var titleView: Binder<TitleView?> {
        return Binder(self.base) { navigationItem, titleView in
            navigationItem.titleView = titleView
        }
    }
    
}
