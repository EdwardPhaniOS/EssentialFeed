//
//  ImageCommentPresenter.swift
//  EssentialFeed
//
//  Created by Tan Vinh Phan on 23/11/2023.
//

import Foundation

public class ImageCommentPresenter {
    
    public static var title: String {
        NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                          tableName: "ImageComments",
                          bundle: Bundle(for: ImageCommentPresenter.self),
                          comment: "Title for the image comments view")
    }
}
