//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 26/02/2023.
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void
    typealias RetrieveCompletion = (RetrieveCachedFeedResult) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedImage], timeStamp: Date, completion: @escaping InsertCompletion)
    func retrieve(completion: @escaping RetrieveCompletion)
}
