//
//  UIColor+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 03/12/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
