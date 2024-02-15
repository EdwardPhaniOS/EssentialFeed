//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 14/09/2023.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    
    public func retrieve(completion: @escaping FeedStore.RetrieveCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map({
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                })
            })
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
            })
        }
    }
    
    public func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.deleteCache(in: context)
            })
        }
    }
    
}
