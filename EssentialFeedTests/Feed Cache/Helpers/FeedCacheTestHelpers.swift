//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 19/03/2023.
//

import Foundation
import EssentialFeed

func uniqueItemFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueImage(), uniqueImage()]
    let local = items.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (items, local)
}

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "anyText", url: anyURL())
}

extension Date {
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .second, value: seconds, to: self)!
    }
    
}
