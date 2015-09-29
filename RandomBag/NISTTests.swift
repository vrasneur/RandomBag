//
//  NISTTests.swift
//  RandomBag
//
//  Created by Vincent on 29/09/2015.
//  Copyright © 2015 Mirandolabs. All rights reserved.
//

import Foundation

protocol StatTest {
    func processBit(bit: Bit)
    
    var pVal: Double { get }
}

class MonobitTest: StatTest {
    var n: Int
    var sn: Int

    
    init() {
        self.n = 0
        self.sn = 0
    }
    
    func processBit(bit: Bit) {
        self.n++
        
        if bit == Bit.Zero {
            self.sn--
        }
        else {
            self.sn++
        }
    }
    
    var sobs: Double {
        return Double(self.sn) / sqrt(Double(self.n))
    }
    
    var pVal: Double {
        return erfc(fabs(self.sobs) / sqrt(2.0))
    }
}