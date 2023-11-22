//
//  SharedLocalizationTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 22/11/2023.
//

import XCTest

func assertLocalizedKeyAndValuesExist(in presentationBundle: Bundle, _ table: String, file: StaticString = #file, line: UInt = #line) {
    let localizationBundles = allLocalizationBundles(in: presentationBundle, file: file, line: line)
    let localizedStringKeys = allLocalizedStringKeys(in: localizationBundles, table: table, file: file, line: line)
    
    localizationBundles.forEach { (bundle, languageCode) in
        localizedStringKeys.forEach { key in
            let localizedString = bundle.localizedString(forKey: key, value: nil, table: table)
            
            if localizedString == key {
                let language = Locale.current.localizedString(forLanguageCode: languageCode) ?? ""
                
                XCTFail("Missing \(language) \(languageCode) localized string for key: '\(key)' in table '\(table)'", file: file, line: line)
                
            }
        }
    }
}

private typealias LocalizedBundle = (bundle: Bundle, languageCode: String)

private func allLocalizationBundles(in bundle: Bundle, file: StaticString = #file, line: UInt = #line) -> [LocalizedBundle] {
    return bundle.localizations.compactMap { languageCode in
        guard
            let path = bundle.path(forResource: languageCode, ofType: "lproj"),
            let localizedBundle = Bundle(path: path)
        else {
            XCTFail("Couldn't find bundle for languageCode: \(languageCode)", file: file, line: line)
            return nil
        }
        
        return (localizedBundle, languageCode)
    }
}

private func allLocalizedStringKeys(in bundles: [LocalizedBundle], table: String, file: StaticString = #file, line: UInt = #line) -> Set<String> {
    return bundles.reduce([]) { (acc, current) in
        guard
            let path = current.bundle.path(forResource: table, ofType: "strings"),
            let strings = NSDictionary(contentsOfFile: path),
            let keys = strings.allKeys as? [String]
        else {
            return acc
        }
        
        return acc.union(Set(keys))
    }
}


