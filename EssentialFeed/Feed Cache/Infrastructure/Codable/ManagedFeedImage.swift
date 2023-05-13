//
//  ManagedFeedImage+CoreDataProperties.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 07/05/2023.
//
//

import CoreData
import EssentialFeed

public class ManagedFeedImage: NSManagedObject {

    @NSManaged public var id: UUID
    @NSManaged public var imageDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var url: URL
    @NSManaged public var cache: ManagedCache?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedFeedImage> {
        return NSFetchRequest<ManagedFeedImage>(entityName: "ManagedFeedImage")
    }

    public static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map({ local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            return managed
        }))
    }
    
    var local: LocalFeedImage {
        return LocalFeedImage(id: id, description: imageDescription, location: location, imageURL: url)
    }
}
