//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 26/02/2023.
//

import Foundation

public final class LocalFeedLoader {
    let store: FeedStore
    var currentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping ((SaveResult) -> Void)) {
        store.deleteCachedFeed(completion: { [weak self] error in
            guard let self = self else { return }
            
            if let deletionError = error {
                completion(deletionError)
            } else {
                self.cache(items, with: completion)
            }
        })
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping ((SaveResult) -> Void)) {
        store.insert(items.toLocal(), timeStamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Array where Element == FeedItem {
    
    func toLocal() -> [LocalFeedItem] {
        return map { LocalFeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.imageURL)
        }
    }
    
}