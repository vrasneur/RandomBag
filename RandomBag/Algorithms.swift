//
//  Algorithms.swift
//  RandomBag
//
//  Created by Vincent on 29/09/2015.
//  Copyright © 2015 Mirandolabs. All rights reserved.
//

import Foundation

func randomPick<T>(array: [T]) -> T? {
    var ret: T?
    
    if array.count > 0 {
        let ridx = randomUniform(UInt(array.count))
        ret = array[Int(ridx)]
    }
    
    return ret
}

// Knuth-Fisher-Yates shuffle
func randomShuffle<T>(inout array: [T]) {
    for idx in (array.count - 1).stride(through: 1, by: -1) {
        let rdx: Int = Int(randomUniform(UInt(idx + 1)))
        
        (array[rdx], array[idx]) = (array[idx], array[rdx])
    }
}

// MARK: GCD functions

func gcd<T:UnsignedIntegerType>(var a: T, var b: T) -> T {
    var t: T = 0
    
    while b != 0 {
        t = b
        b = a % b
        a = t
    }
    
    return a
}

func gcd<T:UnsignedIntegerType>(numbers: T...) -> T {
    return numbers.reduce(T(0), combine: gcd)
}

func gcd<T:UnsignedIntegerType>(numbers: [T]) -> T {
    return numbers.reduce(T(0), combine: gcd)
}

func invertDict<T, U:UnsignedIntegerType>(dict: [T: U]) -> ([(U, T)], U) {
    var vals: [(U, T)] = []
    var sum: U = U(0)
    
    for (key, val) in dict {
        if val != 0 {
            vals.append((val, key))
            sum += val
        }
    }
    
    return (vals, sum)
}

func randomWeightedPick<T, U:UnsignedIntegerType>(dict: [T: U]) -> T? {
    let (vals, total) = invertDict(dict)
    var res: T? = nil
    
    if !vals.isEmpty {
        let gcdVal: U = gcd(vals.map { $0.0 })
        let r: U = randomUniform(total / gcdVal)
        var partialSum: U = 0
        
        for (val, key) in vals {
            partialSum += val / gcdVal
            if partialSum > r {
                res = key
                break;
            }
        }
    }
    
    return res
}

// MARK: weighted random functions

func randomWeightedShuffe<T, U:UnsignedIntegerType>(dict: [T: U]) -> [T] {
    var (vals, total) = invertDict(dict)
    var res: [T] = []
    
    print(vals)
    
    while !vals.isEmpty {
        let gcdVal: U = gcd(vals.map { $0.0 })
        let r: U = randomUniform(total / gcdVal)
        print("g: \(gcdVal) t: \(total) r: \(r)")
        var foundIdx = -1
        var partialSum: U = 0
        
        for (idx, (val, key)) in vals.enumerate() {
            partialSum += val / gcdVal
            if partialSum > r {
                res.append(key)
                total -= val
                foundIdx = idx
                break
            }
        }
        
        if foundIdx != -1 {
            vals.removeAtIndex(foundIdx)
        }
        
        print(vals)
    }
    
    return res
}