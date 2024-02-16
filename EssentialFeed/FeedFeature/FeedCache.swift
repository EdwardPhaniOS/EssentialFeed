//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 30/09/2023.
//

import Foundation

public protocol FeedCache {
    func save(_ items: [FeedImage]) throws
}
