//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 07/05/2023.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(model: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping FeedStore.RetrieveCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map({
                    return CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                })
            })
        }
    }
    
    public func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertCompletion) {
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
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        context.perform { [context] in action(context) }
    }
}

