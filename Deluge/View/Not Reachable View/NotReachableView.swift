//
//  NotReachableView.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import Delugion

@IBDesignable
class NotReachableView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        
        let nib = UINib(nibName: "NotReachableView",
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
    }

}
