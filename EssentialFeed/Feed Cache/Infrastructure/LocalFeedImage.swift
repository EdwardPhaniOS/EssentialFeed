//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 04/03/2023.
//

import Foundation

public struct LocalFeedImage: Equatable, Codable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String? = nil, location: String? = nil, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}

