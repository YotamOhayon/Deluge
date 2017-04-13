//
//  Double+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

extension Double {
    
    var asAngle: Double {
        return self * 3.6
    }
    
    func inUnits(withPrecision precision: Int) -> (Double, Unit) {
        
        let KiB = 1024.0
        let MiB = KiB * 1024.0
        let GiB = MiB * 1024.0
        
        if self >= GiB {
            let size = (self / GiB).setPrecision(to: precision)
            return (size, .GiB)
        }
            
        else if self >= MiB {
            let size = (self / MiB).setPrecision(to: precision)
            return (size, .MiB)
        }
            
        else if self >= KiB {
            let size = (self / KiB).setPrecision(to: precision)
            return (size, .KiB)
        }
            
        else {
            return (self, .B)
        }
        
    }
    
    func setPrecision(to: Int) -> Double {
        
        let divisor = pow(10.0, 1.0)
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
