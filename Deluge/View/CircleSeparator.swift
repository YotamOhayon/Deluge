//
//  CircleSeparator.swift
//  Deluge
//
//  Created by Yotam Ohayon on 21/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class CircleSeparator: UIView {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 5).isActive = true
        self.heightAnchor.constraint(equalToConstant: 5).isActive = true
        self.makeLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeLayout()
    }
    
    func makeLayout() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 2.5
    }

}
