//
//  ProgressView.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    @IBInspectable var trackColor: UIColor {
        get { return self.progressView.trackColor }
        set { self.progressView.trackColor = newValue }
    }
    
    @IBInspectable var progressColor: UIColor {
        get { return self.progressView.progressColors.first ?? .clear }
        set {
            self.progressView.progressColors = [newValue]
            self.progressLabel.textColor = newValue
        }
    }
    
    @IBInspectable var insideColor: UIColor? {
        get { return self.progressView.progressInsideFillColor }
        set { self.progressView.progressInsideFillColor = newValue }
    }
    
    @IBInspectable var angle: Double {
        get { return self.progressView.angle }
        set { self.progressView.angle = newValue }
    }
    
    @IBInspectable var progressNumeric: Int? {
        didSet {
            guard let progressNumeric = self.progressNumeric else {
                self.progressLabel.text = nil
                return
            }
            
            self.checkmarkImageView.isHidden = !(progressNumeric == 100)
            self.progressLabel.isHidden = (progressNumeric == 100)
            self.progressLabel.text = "\(progressNumeric)%"
        }
    }
    
    @IBInspectable var progressNumericColor: UIColor? {
        didSet {
            self.progressLabel.textColor = self.progressNumericColor
        }
    }
    
    private func initSubviews() {
        
        let nib = UINib(nibName: "ProgressView",
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
    }

}
