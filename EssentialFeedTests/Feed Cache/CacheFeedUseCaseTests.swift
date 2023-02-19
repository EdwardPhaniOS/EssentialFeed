//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Tan Vinh Phan on 17/02/2023.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    let store: FeedStore
    var currentDate: () -> Date
    
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem], completion: @escaping ((Error?) -> Void)) {
        store.deleteCachedFeed(completion: { [weak self] error in
            if error == nil {
                guard let self = self else { return }
                self.store.insert(items, timeStamp: self.currentDate(), completion: completion)
            } else {
                completion(error)
            }
        })
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCacheFeed
        case insert([FeedItem], Date)
    }
    
    private(set) var receivedMessage = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessage.append(.deleteCacheFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem], timeStamp: Date, completion: @escaping InsertCompletion) {
        insertionCompletions.append(completion)
        receivedMessage.append(.insert(items, timeStamp))
    }
}

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessage, [])
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        sut.save(items, completion: { _ in })
        
        XCTAssertEqual(store.receivedMessage, [.deleteCacheFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items, completion: { _ in })
        let deletionError = anyError()
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessage, [.deleteCacheFeed])
    }
    
    func test_save_requestNewCacheInsertionWithTimeStampOnSuccessfulDeletion() {
        let timeStamp = Date()
        let (sut, store) = makeSUT(currentDate: { timeStamp })
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items, completion: { _ in })
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.deleteCacheFeed, .insert(items, timeStamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyError()
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyError()
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    func expect(_ sut: LocalFeedLoader, toCompleteWithError error: Error?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var receivedErorr: Error?
        let exp = expectation(description: "Wait for save completion")
        
        let items = [uniqueItem(), uniqueItem()]
        sut.save(items) { error in
            receivedErorr = error
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 4.0)
        
        XCTAssertEqual(receivedErorr as? NSError, error as? NSError, file: file, line: line)
    }
    
    func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), imageURL: anyURL())
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
}
