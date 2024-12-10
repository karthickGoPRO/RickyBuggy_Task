//
//  ImageManagerTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
@testable import RickyBuggy

class DiskCacheManagerTests: XCTestCase {
    
    var diskCacheManager: DiskCacheManager!
    var testKey: String!
    var testData: Data!
    
    override func setUp() {
        super.setUp()
        diskCacheManager = DiskCacheManager()
        testKey = "testImageKey"
        testData = Data("Test image data".utf8)
    }
    
    override func tearDown() {
        diskCacheManager.clearCache()
        diskCacheManager = nil
        super.tearDown()
    }
    
    func testStoreAndFetchImageData() {
        let expectation = self.expectation(description: "Image data stored and fetched")
        
        do {
            try diskCacheManager.storeImageData(testData, forKey: testKey)
        } catch {
            XCTFail("Failed to store image data: \(error)")
        }
        
        if let fetchedData = diskCacheManager.fetchImageData(forKey: testKey) {
            XCTAssertEqual(fetchedData, testData, "Fetched data should match the stored data")
            expectation.fulfill()
        } else {
            XCTFail("Failed to fetch image data")
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchImageDataWhenNotStored() {
        let fetchedData = diskCacheManager.fetchImageData(forKey: "nonExistentKey")
        
        XCTAssertNil(fetchedData, "Fetched data should be nil for a non-existent key")
    }
    
    func testCacheExpiry() {
        let expectation = self.expectation(description: "Image data should expire and be removed")
        
        do {
            try diskCacheManager.storeImageData(testData, forKey: testKey)
        } catch {
            XCTFail("Failed to store image data: \(error)")
        }
        
        Thread.sleep(forTimeInterval: 1)
        
        let fetchedData = diskCacheManager.fetchImageData(forKey: testKey)
        
        XCTAssertNotNil(fetchedData)
        
        expectation.fulfill()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testClearCache() {
        do {
            try diskCacheManager.storeImageData(testData, forKey: testKey)
        } catch {
            XCTFail("Failed to store image data: \(error)")
        }
        
        diskCacheManager.clearCache()
        
        let fetchedData = diskCacheManager.fetchImageData(forKey: testKey)
        XCTAssertNil(fetchedData, "Fetched data should be nil after cache is cleared")
    }
    
    func testImageDataSynchronizerWithCacheAvailable() {
        let expectation = self.expectation(description: "Image data synchronizer callback triggered")
        
        do {
            try diskCacheManager.storeImageData(testData, forKey: testKey)
        } catch {
            XCTFail("Failed to store image data: \(error)")
        }
        
        diskCacheManager.imageDataSyncronizer(forKey: testKey, cacheAvailable: { data in
            XCTAssertEqual(data, self.testData, "The callback should be called with the stored data")
            expectation.fulfill()
        }, cacheNotAvailableHitAPI: {
            XCTFail("The callback should not call API when cache is available")
        })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testImageDataSynchronizerWithCacheNotAvailable() {
        let expectation = self.expectation(description: "Image data synchronizer callback for cache not available triggered")
        
        diskCacheManager.imageDataSyncronizer(forKey: "nonExistentKey", cacheAvailable: { data in
            XCTFail("The callback should not be called when data is not available")
        }, cacheNotAvailableHitAPI: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
