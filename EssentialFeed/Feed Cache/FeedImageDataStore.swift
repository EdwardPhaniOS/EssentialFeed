//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 05/09/2023.
//

import Foundation

public protocol FeedImageDataStore {
    
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}
