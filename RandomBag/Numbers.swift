//
//  Numbers.swift
//  RandomBag
//
//  Created by Vincent on 29/09/2015.
//  Copyright © 2015 Mirandolabs. All rights reserved.
//

import Foundation
import Security

// CSPRNG wrapper functions

func randomUniform<T:UnsignedIntegerType>(upper_bound: T) -> T {
    var r: T = 0

    if upper_bound < 2 {
        return 0
    }
    
    let min: T = (0 &- upper_bound) % upper_bound
    
    while true {
        let result = withUnsafeMutablePointer(&r, { (ptr) -> Int32 in
                         let uint8Ptr = unsafeBitCast(ptr, UnsafeMutablePointer<UInt8>.self)
                         return SecRandomCopyBytes(kSecRandomDefault, sizeofValue(r), uint8Ptr)
                       })
        if result == 0 && r >= min {
            break
        }
    }
    
    return r % upper_bound
}

func randomUniform<T:UnsignedIntegerType>() -> T {
    var r: T = 0

    while true {
        let result = withUnsafeMutablePointer(&r, { (ptr) -> Int32 in
                         let uint8Ptr = unsafeBitCast(ptr, UnsafeMutablePointer<UInt8>.self)
                         return SecRandomCopyBytes(kSecRandomDefault, sizeofValue(r), uint8Ptr)
                                              })
        if result == 0 {
            break
        }
    }
    
    return r
}

class RandomSequence<T:UnsignedIntegerType>: SequenceType {
    let nb: Int
    
    init(nb: Int) {
        self.nb = nb
    }
    
    func generate() -> AnyGenerator<T> {
        var idx: Int = 0
        
        return anyGenerator {
            if idx >= self.nb {
                return nil
            }
            
            let r: T = randomUniform()
            idx++
            
            return r
        }
    }
}

class RandomBitSequence<T:UnsignedIntegerType>: SequenceType {
    let nb: Int
    
    init(nb: Int) {
        self.nb = nb
    }
    
    func generate() -> AnyGenerator<Bit> {
        var idx: Int = 0
        var bitIdx: UIntMax = 0
        var r: T = 0
        var gen = true
        
        return anyGenerator {
            if idx >= self.nb {
                return nil
            }
            
            if gen {
                r = randomUniform()
                bitIdx = UIntMax((8 * sizeof(T)) - 1)
                gen = false
            }
            
            let bit: Bit = ((r.toUIntMax() >> bitIdx) & 1) == 1 ? Bit.One : Bit.Zero
            
            if bitIdx == 0 {
                gen = true
                idx++
            }
            else {
                bitIdx--
            }
            
            return bit
        }
    }
}
