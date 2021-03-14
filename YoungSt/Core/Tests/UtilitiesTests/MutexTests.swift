//
//  File.swift
//  
//
//  Created by Nikita Patskov on 14.03.2021.
//

import Foundation
import XCTest
@testable import Utilities

final class MutexTests: XCTestCase {
    
    func testPHThreadMutex() {
        let mutex = PThreadMutex(type: .normal)
        executeMutexTest(mutex: mutex)
    }
    
    func testPHThreadRecursiveMutex() {
        let mutex = PThreadMutex(type: .recursive)
        executeMutexTest(mutex: mutex)
    }
    
    func testUnfairLock() {
        let mutex = UnfairLock()
        executeMutexTest(mutex: mutex)
    }
    
    private func executeMutexTest(mutex: ScopedMutex) {
        var dictionary: [Int: Int] = [:]
        
        DispatchQueue.concurrentPerform(iterations: 1000) { iteration in
            let value = Int.random(in: 0..<10)
            mutex.sync {
                dictionary[value, default: 0] += 1
            }
        }
    }
    
}
