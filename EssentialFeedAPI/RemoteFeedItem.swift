//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 04/03/2023.
//

import Foundation

 struct RemoteFeedItem: Decodable {
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
