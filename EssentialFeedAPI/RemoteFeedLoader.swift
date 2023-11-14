//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 25/12/2022.
//

import Foundation
import EssentialFeed

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map(_:_:))
    }
}



