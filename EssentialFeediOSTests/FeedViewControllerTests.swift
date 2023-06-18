//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Tan Vinh Phan on 18/06/2023.
//

import XCTest

final class FeedViewController {
    
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        
    }
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
