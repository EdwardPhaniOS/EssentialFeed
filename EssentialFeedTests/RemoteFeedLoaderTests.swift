//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 19/12/2022.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        //Init RemoteFeedLoader does not request data
        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://abcv.com.vn")!
        let (sut, client) = makeSUT(url: url)
       
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    
    //MARK: - Helpers
    //
    private func makeSUT(url: URL = URL(string: "https://abcv.com.vn")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
