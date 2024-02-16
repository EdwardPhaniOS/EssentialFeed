//
//  NullStore.swift
//  EssentialApp
//
//  Created by Vinh Phan on 14/02/2024.
//

import Foundation
import EssentialFeed

class NullStore: FeedStore & FeedImageDataStore {
    
    func deleteCachedFeed() throws {}
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date) throws {}
    
    func retrieve() -> CachedFeed? { .none }
    
    func insert(_ data: Data, for url: URL) throws { }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        .none
    }
}
