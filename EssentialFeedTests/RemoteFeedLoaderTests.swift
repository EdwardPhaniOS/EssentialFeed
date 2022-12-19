//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 19/12/2022.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        let _ = RemoteFeedLoader()
        //Init RemoteFeedLoader does not request data
        XCTAssertNil(client.requestedURL)
    }

}
