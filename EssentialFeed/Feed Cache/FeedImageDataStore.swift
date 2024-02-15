//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 05/09/2023.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
