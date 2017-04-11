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
    
    var progressView: ProgressType {
        
        switch self.state {
        case .downloading:
            let view = KDCircularProgress()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.angle = 90
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "30"
            view.addSubview(label)
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            return .numeric(view)
        case .error:
            return .other(#imageLiteral(resourceName: "x"))
        case .seeding:
            return .other(#imageLiteral(resourceName: "v"))
        default:
            return .other(#imageLiteral(resourceName: "x"))
        }
        
    }
    
}
