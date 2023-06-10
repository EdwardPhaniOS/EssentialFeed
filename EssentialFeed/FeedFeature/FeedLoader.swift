//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 19/12/2022.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}


