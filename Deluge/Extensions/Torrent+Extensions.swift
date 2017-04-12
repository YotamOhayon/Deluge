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

extension Torrent {
    
    var progressView: UIView? {
        
        switch self.state {
        case .downloading:
            let progressView = KDCircularProgress()
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.angle = (self.progress ?? 0).asAngle
            progressView.progressThickness = 0.3
            progressView.trackThickness = 0.3
            progressView.trackColor = .gray
            progressView.progressColors = [.blue]
            return progressView
        case .paused:
            let progressView = KDCircularProgress()
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.angle = (self.progress ?? 0).asAngle
            progressView.progressThickness = 0.3
            progressView.trackThickness = 0.3
            progressView.trackColor = .lightGray
            progressView.progressColors = [.darkGray]
            return progressView
        case .error:
            return UIImageView(image: #imageLiteral(resourceName: "x"))
        case .seeding:
            return UIImageView(image: #imageLiteral(resourceName: "v"))
        default:
            return nil
        }
        
    }
    
    var progressLabel: UILabel? {
        switch self.state {
        case .downloading, .paused:
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = String(describing: (self.progress ?? 0).setPrecision(to: 0))
            return label
        default:
            return nil
        }
    }
    
}
