//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 14/08/2023.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    private class ViewSpy {
        let messages = [Any]()
    }
}
