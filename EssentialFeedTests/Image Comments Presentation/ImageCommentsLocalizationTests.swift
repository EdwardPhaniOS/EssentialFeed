//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 23/11/2023.
//

import XCTest
import EssentialFeed

final class ImageCommentsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let presentationBundle = Bundle(for: ImageCommentsPresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: presentationBundle, table)
    }
}
