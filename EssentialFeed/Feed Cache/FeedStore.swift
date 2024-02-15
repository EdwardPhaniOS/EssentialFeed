//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 26/02/2023.
//

import Foundation

public protocol FeedStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertCompletion = (InsertionResult) -> Void
    
    typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)
    typealias RetrievalResult = Swift.Result<CachedFeed?, Error>
    typealias RetrieveCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to aprropriate threads, if needed
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to aprropriate threads, if needed
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertCompletion)
    
    /// The completion handler can be invoked in any thread
    /// Clients are responsible to dispatch to aprropriate threads, if needed
    func retrieve(completion: @escaping RetrieveCompletion)
}
