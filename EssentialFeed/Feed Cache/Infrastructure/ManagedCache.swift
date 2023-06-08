//
//  ManagedCache+CoreDataProperties.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 07/05/2023.
//
//

import CoreData
import EssentialFeed

public class ManagedCache: NSManagedObject {

    @NSManaged public var timestamp: Date
    @NSManaged public var feed: NSOrderedSet
   
}

extension ManagedCache {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCache> {
        return NSFetchRequest<ManagedCache>(entityName: "ManagedCache")
    }
    
    public static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    public static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(in: context).map(context.delete(_:))
        return ManagedCache(context: context)
    }
    
    public var localFeed: [LocalFeedImage] {
        return feed.compactMap({ $0 as? ManagedFeedImage }).map({ LocalFeedImage(id: $0.id, description: $0.imageDescription, location: $0.location, url: $0.url)})
    }
    
}
