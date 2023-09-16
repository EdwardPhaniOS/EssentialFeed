//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 18/03/2023.
//

import XCTest
import EssentialFeed

class ValidateFeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    func test_validateCache_deleteCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache(completion: { _ in })
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessage, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_doesNotdeletesCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache(completion: { _ in })
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_validateCache_doesNotdeletesCacheOnLessThanSevenDayOldCache() {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT { fixedCurrentDate }
        
        sut.validateCache(completion: { _ in })
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_validateCache_deletesCacheOnSevenDayOldCache() {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let sevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT { fixedCurrentDate }
        
        sut.validateCache(completion: { _ in })
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache(completion: { _ in })
        
        sut = nil
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    //MARK: - Helpers

    func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
}

