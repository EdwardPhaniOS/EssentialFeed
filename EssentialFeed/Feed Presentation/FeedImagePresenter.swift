//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 20/08/2023.
//

import Foundation

public class FeedImagePresenter {
    
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
    
}
