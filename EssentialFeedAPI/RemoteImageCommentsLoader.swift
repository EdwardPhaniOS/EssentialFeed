//
//  RemoteFeedImageCommentsLoader.swift
//  EssentialFeedAPI
//
//  Created by Tan Vinh Phan on 11/11/2023.
//

import Foundation
import EssentialFeed

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

extension RemoteImageCommentsLoader {
    
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map(_:from:))
    }
}

