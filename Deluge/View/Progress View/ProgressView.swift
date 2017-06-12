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
    @IBOutlet weak var percentageLabel: UILabel!
    
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
            self.percentageLabel.textColor = newValue
        }
    }
    
    @IBInspectable var angle: Double {
        get { return self.progressView.angle }
        set { self.progressView.angle = newValue }
    }
    
    @IBInspectable var progress: Int? {
        get {
            guard let text = self.progressLabel.text else {
                return nil
            }
            return Int(text)
        }
        set {
            guard let newValue = newValue else {
                self.progressLabel.text = nil
                return
            }
            self.progressLabel.text = String(describing: newValue)
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
