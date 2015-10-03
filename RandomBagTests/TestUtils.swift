//
//  TestUtils.swift
//  Random
//
//  Created by Vincent on 28/09/2015.
//  Copyright © 2015 Mirandolabs. All rights reserved.
//

import Foundation

class StringBitSequence: SequenceType {
    let bits: String
    
    init(bits: String) {
        self.bits = bits
    }
    
    func generate() -> AnyGenerator<Bit> {
        var idx: String.Index = self.bits.startIndex
        
        return anyGenerator {
            var bit: Bit?
            
            while (idx != self.bits.endIndex) && (bit == nil) {
                switch self.bits[idx] {
                case "0":
                    bit = Bit.Zero
                case "1":
                    bit = Bit.One
                default:
                    bit = nil
                }

                idx = idx.advancedBy(1)
            }

            return bit
        }
    }
}