//
//  RandomTests.swift
//  RandomTests
//
//  Created by Vincent on 26/09/2015.
//  Copyright © 2015 Mirandolabs. All rights reserved.
//

import XCTest
@testable import RandomBag

class RandomTests: XCTestCase {
    
    func testGcd() {
        XCTAssertEqual(gcd(UInt(25), UInt(5)), UInt(5))
    }
    
    func testRandomUniform() {
        let r: UInt8 = randomUniform()
        
        XCTAssert(r >= UInt8.min)
        XCTAssert(r <= UInt8.max)
    }
    
    func testRandomPick() {
        let arr = [5, 7, 9]
        let elt = randomPick(arr)
        
        XCTAssert(elt == 5 || elt == 7 || elt == 9)
    }

    func testRandomShuffle() {
        var arr = [1, 7, 2, 3, 9, 6]
        let sortedArr = arr.sort()
        
        randomShuffle(&arr)
        let sortedShuffle = arr.sort()
        
        XCTAssertEqual(sortedArr, sortedShuffle)
    }
 
    func testRandomGenerator() {
        var count = 0
        for bit in RandomBitSequence<UInt64>(nb: 5) {
            print(bit)
            count++
        }
        
        print(count)
    }
    
    func testMonobitNIST1() {
        let epsilon = "1100100100001111110110101010001000100001011010001100001000110100110001001100011001100010100010111000"
        
        let test = MonobitTest()
        for bit in StringBitSequence(bits: epsilon) {
            test.processBit(bit)
        }
        
        XCTAssertEqual(test.n, 100)
        XCTAssertEqual(test.sn, -16)
        XCTAssertEqualWithAccuracy(test.sobs, -1.6, accuracy: 0.000001)
        XCTAssertEqualWithAccuracy(test.pVal, 0.109599, accuracy: 0.000001)
    }

    func testMonobitNIST2() {
        let epsilon = "1011010101"
        
        let test = MonobitTest()
        for bit in StringBitSequence(bits: epsilon) {
            test.processBit(bit)
        }
        
        XCTAssertEqual(test.n, 10)
        XCTAssertEqual(test.sn, 2)
        XCTAssertEqualWithAccuracy(test.sobs, 0.632455532, accuracy: 0.000000001)
        XCTAssertEqualWithAccuracy(test.pVal, 0.527089, accuracy: 0.000001)
    }
    
    /*
    func testMonobit() {
        let nb = 50000000
        var count = 0
        
        for (idx, bit) in RandomBitSequence<UInt64>(nb: nb).enumerate() {
            if idx % 10000000 == 0 {
                print("idx: \(idx) count: \(count)")
            }
            
            if bit == Bit.One {
                count++
            }
            else {
                count--
            }
        }
        
        print("count: \(count)")
        let sobs = Double(count) / sqrt(Double(nb * 8 * sizeof(UInt64)))
        let pval = erfc(fabs(sobs) / sqrt(2.0))
        print(pval)
    }
    */
    
    func testBlockFrequency1() {
        let epsilon = "1100100100001111110110101010001000100001011010001100001000110100110001001100011001100010100010111000"
        
        let test = BlockFrequencyTest(withBlockSize: 10)
        for bit in StringBitSequence(bits: epsilon) {
            test.processBit(bit)
        }
        
        XCTAssertEqual(test.n, 100)
        XCTAssertEqual(test.blockSize, 10)
        XCTAssertEqual(test.blockCount, 10)
        XCTAssertEqualWithAccuracy(test.chiSquared, 7.2, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(test.pVal, 0.706438, accuracy: 0.000001)
    }
    
    func testBlockFrequency2() {
        let epsilon = "0110011010"
        
        let test = BlockFrequencyTest(withBlockSize: 3)
        for bit in StringBitSequence(bits: epsilon) {
            test.processBit(bit)
        }
        
        XCTAssertEqual(test.n, 10)
        XCTAssertEqual(test.blockSize, 3)
        XCTAssertEqual(test.blockCount, 3)
        XCTAssertEqualWithAccuracy(test.chiSquared, 1.0, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(test.pVal, 0.801252, accuracy: 0.000001)
    }
    
    func testRuns1() {
        let epsilon = "1100100100001111110110101010001000100001011010001100001000110100110001001100011001100010100010111000"
        
        let test = RunsTest()
        for bit in StringBitSequence(bits: epsilon) {
            test.processBit(bit)
        }
        
        XCTAssertEqual(test.n, 100)
        XCTAssertEqualWithAccuracy(test.tau, 0.2, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(test.pi, 0.42, accuracy: 0.01)
        XCTAssertEqual(test.vobs, 52)
        XCTAssertEqualWithAccuracy(test.pVal, 0.500798, accuracy: 0.000001)
    }
}
