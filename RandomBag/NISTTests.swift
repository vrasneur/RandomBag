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

class BlockFrequencyTest: StatTest {
    var n: Int
    var blockSize: Int
    var blockCount: Int
    var bitSum: Int
    var bitCount: Int
    var sum: Double
    
    init(withBlockSize blockSize: Int) {
        self.n = 0
        self.blockSize = blockSize
        self.blockCount = 0
        self.bitSum = 0
        self.bitCount = 0
        self.sum = 0.0
    }
    
    func processBit(bit: Bit) {
        self.n++
        self.bitCount++
        
        if bit == Bit.One {
            self.bitSum++
        }
        
        if self.bitCount == self.blockSize {
            let pi = Double(self.bitSum) / Double(self.blockSize)
            self.sum += pow(pi - 0.5, 2.0)
        
            self.bitCount = 0
            self.bitSum = 0
            self.blockCount++
        }
    }
    
    var chiSquared: Double {
        return 4.0 * Double(self.blockSize) * self.sum
    }
    
    var pVal: Double {
        return cephes_igamc(Double(self.blockCount) / 2.0, chiSquared / 2.0)
    }
}

class RunsTest: StatTest {
    var n: Int
    var sum: Int
    var vobs: Int
    var lastBit: Bit?
    
    init() {
        self.n = 0
        self.sum = 0
        self.vobs = 1
    }
    
    func processBit(bit: Bit) {
        self.n++
        
        if bit == Bit.One {
            self.sum++
        }
        
        if (self.lastBit != nil) && (bit != self.lastBit) {
            self.vobs++
        }
        
        self.lastBit = bit
    }
    
    var pi: Double {
        return Double(self.sum) / Double(self.n)
    }
    
    var tau: Double {
        return 2.0 / sqrt(Double(self.n))
    }
    
    var pVal: Double {
        let pi = self.pi
        
        if fabs(pi - 0.5) > self.tau {
            return 0.0
        }
        
        let f = 2.0 * pi * (1.0 - pi)
        let num = fabs(Double(self.vobs) - (Double(self.n) * f))
        let den = sqrt(2.0 * Double(self.n)) * f
        
        return erfc(num / den)
    }
}