//
//  Double+Extensions_Spec.swift
//  DelugeTests
//
//  Created by Yotam Ohayon on 06/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Quick
import Nimble
@testable import Deluge

class DoubleExtensions_Spec: QuickSpec {
    
    override func spec() {
        
        describe("inUnits()") {
            
            it("returns the correct values") {
                
                let KiB = 1024.0
                let MiB = KiB * 1024.0
                let GiB = MiB * 1024.0
                
                expect(0.inUnits(withPrecision: 1) == (0.0, .B)).to(beTrue())
                
                expect((KiB - 1).inUnits(withPrecision: 1) == (1023.0, .B)).to(beTrue())
                expect(KiB.inUnits(withPrecision: 1) == (1.0, .KiB)).to(beTrue())
                
                expect((MiB - KiB).inUnits(withPrecision: 1) == (1023.0, .KiB)).to(beTrue())
                expect((MiB - 1).inUnits(withPrecision: 1) == (1023.9, .KiB)).to(beTrue())
                expect(MiB.inUnits(withPrecision: 1) == (1.0, .MiB)).to(beTrue())
                
                expect((GiB - MiB).inUnits(withPrecision: 1) == (1023.0, .MiB)).to(beTrue())
                expect((GiB - 1).inUnits(withPrecision: 1) == (1023.9, .MiB)).to(beTrue())
                expect(GiB.inUnits(withPrecision: 1) == (1.0, .GiB)).to(beTrue())
                
            }
            
        }
        
        describe("setPrecision") {
            
            it("returns the correct values") {
                
                expect(10.238623.setPrecision(to: 2)).to(equal(10.23))
                expect(10.234623.setPrecision(to: 2)).to(equal(10.23))
                expect(10.234.setPrecision(to: 2)).to(equal(10.23))
                expect(10.234.setPrecision(to: 3)).to(equal(10.234))
                expect(10.setPrecision(to: 3)).to(equal(10.000))
                expect(10.1.setPrecision(to: 3)).to(equal(10.1))
                
            }
            
        }
        
        describe("asHMS") {
            
            it("returns the correct values") {
                
                let minute = 60.0
                let hour = minute * 60.0
                let day = hour * 24.0
                
                expect(0.0.asHMS).to(equal("0s"))
                expect((minute - 1).asHMS).to(equal("59s"))
                expect(minute.asHMS).to(equal("1m"))
                expect((minute + 1).asHMS).to(equal("1m 1s"))
                expect((minute * 2).asHMS).to(equal("2m"))
                expect((hour - 1).asHMS).to(equal("59m 59s"))
                expect(hour.asHMS).to(equal("1h"))
                expect(day.asHMS).to(equal("1d"))
                expect((day + hour + minute + 1).asHMS).to(equal("1d 1h 1m 1s"))
                
            }
            
        }
        
    }
    
}
