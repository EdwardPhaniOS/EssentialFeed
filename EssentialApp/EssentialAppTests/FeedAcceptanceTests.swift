//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by Tan Vinh Phan on 09/10/2023.
//

import XCTest
import EssentialFeed
import EssentialFeediOS
@testable import EssentialApp

class FeedAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feedVC = launch(httpClient: .online(response), store: .empty)
        XCTAssertEqual(feedVC.numberOfRenderedFeedImageViews(), 2)
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        sharedStore.insert(makeImageData0(), for: URL(string: "http://feed.com/image-0")!, completion: { _ in })
        sharedStore.insert(makeImageData1(), for: URL(string: "http://feed.com/image-1")!, completion: { _ in })
        
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData1())
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }
    
    func test_onEnteringBackground_deletesExpiredFeedCache() {
        let store = InMemoryFeedStore.withExpiredFeedCache
        
        enteringBackground(with: store)
        
        XCTAssertNil(store.feedCache, "Expected to keep non-expired cache")
    }
    
    func test_onFeedImageSelection_displaysComments() {
        let commentsVC = showCommentsForFirstImage()
        
        XCTAssertEqual(commentsVC.numberOfRenderedComments(), 1)
        XCTAssertEqual(commentsVC.commentMessage(at: 0), makeCommentMessage())
    }
    
    //MARK: - Helpers
    
    private func launch(httpClient: HTTPClientStub = .offline, store: InMemoryFeedStore = .empty) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let vc = nav?.topViewController as! ListViewController
        vc.loadViewIfNeeded()
        return vc
    }
    
    private func enteringBackground(with store: InMemoryFeedStore) {
        guard let connectedScene = UIApplication.shared.connectedScenes.first else {
            return
        }
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store)
        sut.sceneWillResignActive(connectedScene)
    }
    
    private func showCommentsForFirstImage() -> ListViewController {
        let feedVC = launch(httpClient: .online(response), store: .empty)
        
        feedVC.simulateTapOnFeedImage(at: 0)
        RunLoop.current.run(until: Date())
        
        let nav = feedVC.navigationController
        let vc = nav?.topViewController as! ListViewController
        vc.loadViewIfNeeded()
        return vc
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "image-0": return makeImageData0()
        case "image-1": return makeImageData1()
        case "image-2": return makeImageData2()
            
        case "/essential-feed/v1/feed":
            return makeFeedData()
        case "/essential-feed/v1/image/2AB2AE66-A4B7-4A16-B374-51BBAC8DB086/comments":
            return makeCommentsData()
        default:
            return Data()
        }
    }
    
    private func makeImageData0() -> Data { UIImage.make(withColor: .red).pngData()! }
    private func makeImageData1() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImageData2() -> Data { UIImage.make(withColor: .blue).pngData()! }

    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            "items": [
                ["id": "2AB2AE66-A4B7-4A16-B374-51BBAC8DB086", "image": "http://feed.com/image-0"],
                ["id": "A28F5FE3-27A7-44E9-8DF5-53742D0E4A5A", "image": "http://feed.com/image-1"]
            ]])
    }
    
    private func makeCommentsData() -> Data {
        try! JSONSerialization.data(withJSONObject: ["items": [
            [
                "id": UUID().uuidString,
                "message": makeCommentMessage(),
                "created_at": "2020-05-20T11:24:59+0000",
                "author": [
                    "username": "a username"
                ]
            ] as [String: Any],
        ]])
    }
    
    private func makeCommentMessage() -> String {
        "a message"
    }
}
