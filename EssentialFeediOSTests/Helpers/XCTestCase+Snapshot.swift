//
//  XCTestCase+Snapshot.swift
//  EssentialFeediOSTests
//
//  Created by Tan Vinh Phan on 16/10/2023.
//

import XCTest

extension XCTest {
    
    func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot befor asserting.", file: file, line: line)
            return
        }
        
        if snapshotData != storedSnapshotData {
            var temporarySnapshotURL: URL!
            
            if #available(iOS 16.0, *) {
                temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                    .appending(path: snapshotURL.lastPathComponent)
            } else {
                temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(snapshotURL.lastPathComponent)
            }
            
            try? snapshotData?.write(to: temporarySnapshotURL)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL \(snapshotURL)", file: file, line: line)
        }
    }
    
    func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true)
            
            try snapshotData?.write(to: snapshotURL)
            XCTFail("Recored succeeded - use `assert` to compare the snapshot from now on.", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        var snapshotURL: URL!
        if #available(iOS 16.0, *) {
            snapshotURL = URL(fileURLWithPath: String(describing: file))
                .deletingLastPathComponent()
                .appending(component: "snapshots")
                .appending(component: "\(name).png")
        } else {
            snapshotURL = URL(fileURLWithPath: String(describing: file))
                .deletingLastPathComponent()
                .appendingPathComponent("snapshots")
                .appendingPathComponent("\(name).png")
        }
        
        return snapshotURL
    }
    
    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        return data
    }
}
