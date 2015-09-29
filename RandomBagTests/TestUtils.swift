//
//  TestUtils.swift
//  Random
//
//  Created by Vincent on 28/09/2015.
//  Copyright © 2015 Mirandosoft. All rights reserved.
//

import Foundation

class StringBitSequence: SequenceType {
    let str: String
    
    init(str: String) {
        self.str = str
    }
    
    func generate() -> AnyGenerator<Bit> {
        var idx: String.Index = self.str.startIndex
        
        return anyGenerator {
            var bit: Bit?
            
            while (idx != self.str.endIndex) && (bit == nil) {
                switch self.str[idx] {
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