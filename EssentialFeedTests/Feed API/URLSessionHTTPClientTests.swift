//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 15/01/2023.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { _, _, _ in
            
        }
    }
    
    
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receiveURLs, [url])
    }
    
    private class URLSessionSpy: URLSession {
        var receiveURLs = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.receiveURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask { }
    
}
