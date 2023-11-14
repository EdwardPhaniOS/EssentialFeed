//
//  RemoteLoader.swift
//  EssentialFeedAPITests
//
//  Created by Tan Vinh Phan on 13/11/2023.
//

import XCTest
import EssentialFeed
import EssentialFeedAPI

final class RemoteLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
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
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnMapperError() {
        let (sut, client) = makeSUT(mapper: { _, _ in
            throw anyNSError()
        })
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            client.complete(withStatusCode: 200, data: anyData())
        })
    }
    
    func test_load_deliversMappedResource() {
        let resource = "a resource"
        let (sut, client) = makeSUT(mapper: { data, _ in
            String(data: data, encoding: .utf8)!
        })
        
        expect(sut, toCompleteWith: .success(resource), when: {
            client.complete(withStatusCode: 200, data: Data(resource.utf8))
        })
    }
    
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url!, client: client)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON(items: []))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK: - Helpers
    //
    private func makeSUT(url: URL = URL(string: "https://abcv.com.vn")!,
                         mapper: @escaping RemoteLoader<String>.Mapper = { _, _ in "any" },
                         file: StaticString = #file,
                         line: UInt = #line
    ) -> (sut: RemoteLoader<String>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader<String>(url: url, client: client, mapper: mapper)
        trackForMemoryLeak(client)
        trackForMemoryLeak(sut)

        return (sut, client)
    }
    
    func failure(_ error: RemoteLoader<String>.Error) -> RemoteLoader<String>.Result {
        return .failure(error)
    }
    
    private func makeItemsJSON(items: [[String: Any]]) -> Data {
        let itemsJSON = [
            "items": items
        ]
        let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
        return json
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: UUID(), description: description, location: location, url: imageURL)
        
        let json = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.url.absoluteString
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func expect(_ sut: RemoteLoader<String>, toCompleteWith expectedResult: RemoteLoader<String>.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems),
                .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
    
            case let (.failure(receivedError as RemoteLoader<String>.Error),
                .failure(expectedError as RemoteLoader<String>.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }

}
