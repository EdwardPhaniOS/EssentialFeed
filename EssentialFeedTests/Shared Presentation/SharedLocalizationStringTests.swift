//
//  SharedLocalizationStringTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 22/11/2023.
//

import XCTest
import EssentialFeed

final class SharedLocalizationStringTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let presentationBundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        assertLocalizedKeyAndValuesExist(in: presentationBundle, table)
    }
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) { }
    }
    
}
