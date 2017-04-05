//
//  UnitSpec.swift
//  Deluge
//
//  Created by Yotam Ohayon on 14/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Deluge

class UnitSpec: QuickSpec {
    
    override func spec() {
        
        describe("strigified") {
            
            it("returns the correct value") {
                
                expect(Deluge.Unit.B.stringified).to(equal("B"))
                expect(Deluge.Unit.KiB.stringified).to(equal("KiB"))
                expect(Deluge.Unit.MiB.stringified).to(equal("MiB"))
                expect(Deluge.Unit.GiB.stringified).to(equal("GiB"))
                
            }
            
        }
        
        describe("stringifiedAsSpeed") {
            
            it("returns the correct value") {
                
                expect(Deluge.Unit.B.stringifiedAsSpeed).to(equal("B/s"))
                expect(Deluge.Unit.KiB.stringifiedAsSpeed).to(equal("KiB/s"))
                expect(Deluge.Unit.MiB.stringifiedAsSpeed).to(equal("MiB/s"))
                expect(Deluge.Unit.GiB.stringifiedAsSpeed).to(equal("GiB/s"))
                
            }
            
        }
        
    }
    
}
