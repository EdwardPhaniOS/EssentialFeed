//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedAPITests
//
//  Created by Tan Vinh Phan on 11/11/2023.
//

import XCTest
import EssentialFeed
import EssentialFeedAPI

final class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {

    func test_load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 150, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    //MARK: - Helpers

    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
        let client: HTTPClientSpy = HTTPClientSpy()
        let sut = RemoteImageCommentsLoader(url: url, client: client, mapper: ImageCommentsMapper.map)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String : Any]) {
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        
        let json: [String: Any] = [
            "id": id.uuid,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "user_name": username
            ]
        ]
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String : Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteImageCommentsLoader, toCompleteWith expectedResult: RemoteImageCommentsLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 5.0)
    }

}
