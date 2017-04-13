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
                expect((MiB - 1).inUnits(withPrecision: 1) == (1024.0, .KiB)).to(beTrue())
                expect(MiB.inUnits(withPrecision: 1) == (1.0, .MiB)).to(beTrue())
                
                expect((GiB - MiB).inUnits(withPrecision: 1) == (1023.0, .MiB)).to(beTrue())
                expect((GiB - 1).inUnits(withPrecision: 1) == (1024.0, .MiB)).to(beTrue())
                expect(GiB.inUnits(withPrecision: 1) == (1.0, .GiB)).to(beTrue())
                
            }
            
        }
        
    }
    
}
