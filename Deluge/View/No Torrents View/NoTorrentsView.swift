//
//  NoTorrentsView.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/06/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class NoTorrentsView: UIView {

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
        
        let nib = UINib(nibName: "NoTorrentsView",
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
    }

}
