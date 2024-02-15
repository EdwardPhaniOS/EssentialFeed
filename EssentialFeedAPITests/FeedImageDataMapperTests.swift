//
//  FeedImageDataMapper.swift
//  EssentialFeedAPITests
//
//  Created by Tan Vinh Phan on 18/11/2023.
//

import XCTest
import EssentialFeedAPI
import EssentialFeed

final class FeedImageDataMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach({ code in
            XCTAssertThrowsError( try {
                try FeedImageDataMapper.map(anyData(), from: HTTPURLResponse(statusCode: code))
            }(), "Expected error to be thrown for status code \(code)")
        })
    }
    
    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyData = Data()
        XCTAssertThrowsError( try {
            try FeedImageDataMapper.map(emptyData, from: HTTPURLResponse(statusCode: 200))
        }())
    }
    
    func test_map_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty data".utf8)
        let result = try FeedImageDataMapper.map(nonEmptyData, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, nonEmptyData)
    }
}
