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
        XCTAssertEqual(client.requestedURLs, [])
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://abcv.com.vn")!
        let (sut, client) = makeSUT(url: url)
       
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://abcv.com.vn")!
        let (sut, client) = makeSUT(url: url)
       
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .connectivity) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { (index, code) in
            
            expect(sut, toCompleteWithError: .invalidData) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversNoItemOn200HTTPResposeWithEmptyJSON() {
        let (sut, client) = makeSUT()
        
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut.load { capturedResults.append($0) }
        
        let emptyListJSON = Data("{ \"item\": [] }".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)
        
        XCTAssertEqual(capturedResults, [.success([])])
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .invalidData) {
            let invalidData = Data("Invalid data".utf8)
            client.complete(withStatusCode: 200, data: invalidData)
        }
    }
    
    
    //MARK: - Helpers
    //
    private func makeSUT(url: URL = URL(string: "https://abcv.com.vn")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithError error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) -> Void {
            messages[index].completion(HTTPClientResult.failure(error))
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0, data: Data = Data()) -> Void {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success(data, response))
            
        }
    }
}
