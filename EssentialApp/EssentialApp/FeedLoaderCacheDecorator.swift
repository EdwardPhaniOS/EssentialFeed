//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Tan Vinh Phan on 30/09/2023.
//

import EssentialFeed

public class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }
}
 
private extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed, completion: { _ in })
    }
}