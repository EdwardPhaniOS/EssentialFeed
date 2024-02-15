//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 20/08/2023.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}

