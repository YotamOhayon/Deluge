//
//  Torrent+Extensions.swift
//  Deluge
//
//  Created by Yotam Ohayon on 11/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import UIKit
import Delugion
import KDCircularProgress

enum ProgressType {
    case numeric(KDCircularProgress)
    case other(UIImage)
}

extension TorrentProtocol {
    
    var progressInfo: ProgressInfo? {
        
        let labelWithColor: (UIColor) -> UILabel = { color in
            let label = UILabel()
            label.text = String(describing: (self.progress ?? 0).setPrecision(to: 0))
            label.textColor = color
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            return label
        }
        
        let view = { () -> UIView in
            switch self.state {
            case .downloading:
                return labelWithColor(.blue)
            case .paused:
                return labelWithColor(.gray)
            case .seeding:
                return UIImageView(image: #imageLiteral(resourceName: "v"))
            default:
                return UIImageView(image: #imageLiteral(resourceName: "x"))
            }
        }()
        
        let progressColor = { () -> UIColor in
         
            switch self.state {
            case .downloading:
                return .blue
            case .paused:
                return .lightGray
            case .error:
                return .red
            case .seeding:
                return .green
            default:
                return .red
            }
            
        }()
        
        let angle = (self.progress ?? 0).asAngle
        
        return ProgressInfo(angle: angle, progressColor: progressColor, view: view)
        
    }
    
}
