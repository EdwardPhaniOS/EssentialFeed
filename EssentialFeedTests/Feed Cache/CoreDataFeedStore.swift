//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 07/05/2023.
//

import CoreData
import EssentialFeed

public final class CoreDataFeedStore: FeedStore {
    public init() {}
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrieveCompletion) {
        
    }
  
}

private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var ur: URL
    @NSManaged var cache: ManagedCache
}
