//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 20/08/2023.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

