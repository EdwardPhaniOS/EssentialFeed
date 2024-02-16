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
        
        store.completeRetrieval(with: anyNSError())
        
        try? sut.validateCache()
        
        XCTAssertEqual(store.receivedMessage, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_doesNotdeletesCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        try? sut.validateCache()
        
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_validateCache_doesNotdeletesCacheOnLessThanSevenDayOldCache() {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT { fixedCurrentDate }
        
        try? sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_validateCache_deletesCacheOnSevenDayOldCache() {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let sevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT { fixedCurrentDate }
        
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)
        
        try? sut.validateCache()
       
        XCTAssertEqual(store.receivedMessage, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(deletionError)) {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfFailedRetrieval() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(Void())) {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletionSuccessfully()
        }
    }
    
    func test_validateCache_succeedsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(Void())) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_validateCache_succeedsOnNonExpiredCache() {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
            
        expect(sut, toCompleteWith: .success(Void())) {
            store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        }
    }
    
    func test_validateCache_failsOnDeletionErrorOfExpiredCache() {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(deletionError)) {
            store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfExpiredCache() {
        let feed = uniqueItemFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success(Void())) {
            store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
            store.completeDeletionSuccessfully()
        }
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        try? sut?.validateCache()
        
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
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        action()
        
        let receivedResult = Result { try sut.validateCache() }
        
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}


private extension Date {
    
    func minusFeedCacheMaxAge() -> Date {
        let days = -FeedCachePolicy.maxCacheAgeInDays
        return self.adding(days: days)
    }
}
