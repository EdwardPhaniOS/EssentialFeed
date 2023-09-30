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
    let calendar = Calendar(identifier: .gregorian)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader: FeedCache {
    public typealias SaveResult = FeedCache.Result
    
    public func save(_ items: [FeedImage], completion: @escaping ((SaveResult) -> Void)) {
        store.deleteCachedFeed { [weak self] deletionResult in
            guard let self = self else { return }
            
            switch deletionResult {
            case .success:
                self.cache(items, with: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ items: [FeedImage], with completion: @escaping ((SaveResult) -> Void)) {
        store.insert(items.toLocal(), timestamp: self.currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }
            
            switch insertionResult {
            case .success:
                completion(.success(Void()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] rs in
            guard let self = self else { return }
            switch rs {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(.some(cachedFeed)) where FeedCachePolicy.validate(cachedFeed.timestamp, against: self.currentDate()):
                completion(.success(cachedFeed.feed.toModels()))
                
            case .success:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public typealias ValidationResult = Result<Void, Error>
    
    public func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.retrieve { [weak self] rs in
            guard let self = self else { return }
            switch rs {
            case .failure:
                self.store.deleteCachedFeed(completion: completion)
                
            case let .success(.some(cachedFeed)) where !FeedCachePolicy.validate(cachedFeed.timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed(completion: completion)
                
            case .success:
                completion(.success(Void()))
            }
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
        }
    }
}
