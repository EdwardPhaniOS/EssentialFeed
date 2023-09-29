//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialAppTests
//
//  Created by Tan Vinh Phan on 29/09/2023.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
