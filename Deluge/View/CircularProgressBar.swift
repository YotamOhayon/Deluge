//
//  CircularProgressBar.swift
//  CircularProgressBar
//
//  Created by Yotam Ohayon on 10/11/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CircularProgressBar: UIView {
    
    @IBInspectable var font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 15 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var progress: CGFloat = 25 {
        didSet {
            if progress < 0 {
                progress = 0
            }
            if progress > 100 {
                progress = 100
            }
            setNeedsLayout()
        }
    }
    
    @IBInspectable var color: UIColor = .blue {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var image: UIImage? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var showProgress = true

    private let imageLayer = CALayer()
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let textLayer = CATextLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
    }

}

fileprivate extension CircularProgressBar {
    
    func configure() {
        self.backgroundColor = .clear
        trackLayer.fillColor = UIColor.clear.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    func setup() {
        let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(self.bounds.width,
                         self.bounds.height) / 2 - (self.lineWidth / 2)
        let startAngle = 3 * CGFloat.pi / 2
        let progressInDegress: CGFloat = self.progress * 3.6
        let progressInRadians = degressToRadians(progressInDegress)
        let endAngle = progressInRadians
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        progressLayer.frame = self.bounds
        progressLayer.lineWidth = self.lineWidth
        progressLayer.strokeColor = self.color.cgColor
        progressLayer.path = path.cgPath
        progressLayer.lineCap = kCALineCapRound
        
        let trackPath = UIBezierPath(arcCenter: arcCenter,
                                     radius: radius,
                                     startAngle: startAngle,
                                     endAngle: degressToRadians(360),
                                     clockwise: true)
        trackPath.close()
        trackLayer.frame = self.bounds
        trackLayer.lineWidth = self.lineWidth
        trackLayer.strokeColor = UIColor(red: 239, green: 239, blue: 244).cgColor
        trackLayer.path = trackPath.cgPath
        
        if let image = self.image {
            self.setupImage(image)
        } else {
            self.setupTextLayer()
        }
        
    }
    
    private func setupImage(_ image: UIImage) {
        
        let size = CGSize(width: bounds.width * 0.35,
                          height: bounds.height * 0.35)
        let origin = CGPoint(x: bounds.midX - size.width / 2,
                             y: bounds.midY - size.height / 2)
        imageLayer.frame = CGRect(origin: origin, size: size)
        
        imageLayer.contents = image.cgImage
        imageLayer.contentsGravity = kCAGravityResizeAspect
        progressLayer.fillColor = self.color.cgColor //UIColor(red: 0, green: 117, blue: 255).cgColor
        progressLayer.strokeColor = self.color.cgColor //UIColor(red: 0, green: 117, blue: 255).cgColor
        
        self.layer.addSublayer(imageLayer)
        
    }
    
    private func setupTextLayer() {
        
        guard self.showProgress else {
            return
        }
        
        let text: NSString = "\(Int(self.progress))%" as NSString
        let font = self.font.withSize(self.fontSize)
        let attr = [NSAttributedStringKey.font: font]
        let textSize = text.boundingRect(with: self.bounds.size,
                                         options: .usesLineFragmentOrigin,
                                         attributes: attr,
                                         context: nil).size
        let textOrigin = CGPoint(x: bounds.midX - textSize.width / 2,
                                 y: bounds.midY - textSize.height / 2)
        textLayer.frame = CGRect(origin: textOrigin,
                                 size: textSize)
        textLayer.string = text
        
        textLayer.font = CTFontCreateWithName(font.fontName as CFString,
                                              self.fontSize,
                                              nil)
        textLayer.fontSize = self.fontSize
        textLayer.foregroundColor = self.color.cgColor
        textLayer.isWrapped = true
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(textLayer)
        
    }
    
}

//extension Reactive where Base: CircularProgressBar {
//
//    var color: Binder<UIColor> {
//        return Binder(self.base) { view, color in
//            view.color = color
//        }
//    }
//
//    var progress: Binder<Double> {
//        return Binder(self.base) { view, progress in
//            view.progress = CGFloat(progress)
//        }
//    }
//
//    var image: Binder<UIImage?> {
//        return Binder(self.base) { view, image in
//            view.image = image
//        }
//    }
//
//}

private func radiansToDegress(_ radians: CGFloat) -> CGFloat {
    return radians * 180 / CGFloat.pi
}

private func degressToRadians(_ degress: CGFloat) -> CGFloat {
    return (degress + 270) * CGFloat.pi / 180
}
