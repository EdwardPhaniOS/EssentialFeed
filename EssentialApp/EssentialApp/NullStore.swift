//
//  NullStore.swift
//  EssentialApp
//
//  Created by Vinh Phan on 14/02/2024.
//

import Foundation
import EssentialFeed

class NullStore: FeedStore & FeedImageDataStore {
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(.success(Void()))
    }
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertCompletion) {
        completion(.success(Void()))
    }
    
    func retrieve(completion: @escaping RetrieveCompletion) {
        completion(.success(.none))
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        completion(.success(Void()))
    }
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
}
