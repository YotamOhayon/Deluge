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
    
    func setPrecision(to powValue: Int) -> Double {
        
        let divisor = pow(10.0, Double(powValue))
        let temp = modf(self * divisor).0
        return temp / divisor
        
    }
    
    var asHMS: String? {
        
        let secondsInMinute = 60
        let secondsInHour = secondsInMinute * 60
        let secondsInDay = secondsInHour * 24
        
        let asInt = Int(self)
        
        let (d, h, m, s) = (asInt / secondsInDay,
                            (asInt / secondsInHour) % 24,
                            (asInt % secondsInHour) / secondsInMinute,
                            (asInt % secondsInHour) % secondsInMinute)
        
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
        if eta.count == 0 && s == 0 {
            return "0s"
        }
        return eta.joined(separator: " ")
        
    }
    
}
