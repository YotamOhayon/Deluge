//
//  TitleView.swift
//  Deluge
//
//  Created by Yotam Ohayon on 17/06/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!

    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            self.subtitleLabel.text = subtitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func initSubviews() {
        
        let nib = UINib(nibName: "TitleView",
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
    }

}
