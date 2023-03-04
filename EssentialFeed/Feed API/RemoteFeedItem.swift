//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 04/03/2023.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
