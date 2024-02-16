//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 12/03/2023.
//

import EssentialFeed

class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessage = [ReceivedMessage]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedFeed?, Error>?
    
    func deleteCachedFeed() throws {
        receivedMessage.append(.deleteCacheFeed)
        try deletionResult?.get()
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        receivedMessage.append(.insert(feed, timestamp))
        try insertionResult?.get()
    }
    
    func retrieve() throws -> CachedFeed? {
        receivedMessage.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionResult = .failure(error)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrievalResult = .success(CachedFeed(feed: feed, timestamp: timestamp))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionResult = .success(Void())
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(Void())
    }
    
}
