//
//  Double+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

extension Double {
    
    func inUnits() -> (Double, Unit) {
        
        if self >= 1073741824 {
            let size = (self / 1073741824).setPrecision(to: 1)
            return (size, .gb)
        }
            
        else if self >= 1048576 {
            let size = (self / 1048576).setPrecision(to: 1)
            return (size, .mb)
        }
            
        else if self >= 1024 {
            let size = (self / 1024).setPrecision(to: 1)
            return (size, .kb)
        }
            
        else {
            return (self, .byte)
        }
        
    }
    
    func setPrecision(to: Int) -> Double {
        
        let divisor = pow(10.0, Double(1))
        return (self * divisor).rounded() / divisor
        
    }
    
    var asHMS: String? {
        
        let asInt = Int(self)
        
        let (d, h, m, s) = (asInt / 86400, asInt / 3600, (asInt % 3600) / 60, (asInt % 3600) % 60)
        
        var eta = [String]()
        if d > 0 {
            eta.append("\(d)d")
        }
        if h > 0 {
            eta.append("\(h)h")
        }
        if m > 0 {
            eta.append("\(m)m")
        }
        if s > 0 {
            eta.append("\(s)s")
        }
        return eta.joined(separator: " ")
        
    }
    
}
