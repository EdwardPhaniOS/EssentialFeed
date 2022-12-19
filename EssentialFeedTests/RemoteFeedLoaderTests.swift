//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 19/12/2022.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClientSpy.shared.get(from: URL(string: "https://abcv.com.vn"))
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL) { }
}

class HTTPClientSpy: HTTPClient {
    
    override func get(from url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
    
}


final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let _ = RemoteFeedLoader()
        //Init RemoteFeedLoader does not request data
        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
