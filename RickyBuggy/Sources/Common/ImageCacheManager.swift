//
//  ImageCacheManager.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import Foundation

final class DiskCacheManager {
    private let memoryCache = NSCache<NSString, NSData>()
    private let cacheDirectory: URL
    private let fileManager: FileManager
    private let queue: DispatchQueue
    private let cacheExpiryDuration: TimeInterval = 15 * 24 * 60 * 60 // 15 days
    
    init() {
        self.fileManager = FileManager.default
        self.queue = DispatchQueue(label: "com.imageCacheManager.queue", attributes: .concurrent)
        
        // Set up the cache directory
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to access the Documents directory.")
        }
        self.cacheDirectory = documentsDirectory.appendingPathComponent("ImageCache", isDirectory: true)
        
        // Create the cache directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create cache directory: \(error)")
            }
        }
    }
    
    private func filePath(forKey key: String) -> URL {
        let sanitizedKey = key
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
        return cacheDirectory.appendingPathComponent(sanitizedKey)
    }
    
    // Store image data in memory and on disk
    func storeImageData(_ data: Data, forKey key: String) throws {
        let path = filePath(forKey: key)
        
        // Add to memory cache
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        
        // Write to disk asynchronously with error handling and barrier for thread safety
        queue.async(flags: .barrier) {
            do {
                try data.write(to: path)
                // Set file creation date for expiry tracking
                try self.fileManager.setAttributes([.creationDate: Date()], ofItemAtPath: path.path)
            } catch {
                print("Failed to store image data on disk: \(error)")
            }
        }
    }
    
    // Fetch image data from cache without expiry duration as an argument
    func fetchImageData(forKey key: String) -> Data? {
        // Check memory cache first
        if let data = memoryCache.object(forKey: key as NSString) {
            return data as Data
        }
        
        // If not found in memory, check disk cache
        let path = filePath(forKey: key)
        var data: Data? = nil
        
        queue.sync {
            guard let attributes = try? fileManager.attributesOfItem(atPath: path.path),
                  let creationDate = attributes[.creationDate] as? Date else {
                return
            }
            
            // Check if the cached data has expired
            if Date().timeIntervalSince(creationDate) <= cacheExpiryDuration {
                data = try? Data(contentsOf: path)
                if let data = data {
                    // Store the data in memory cache after loading from disk
                    self.memoryCache.setObject(data as NSData, forKey: key as NSString)
                }
            } else {
                // Remove expired cache item
                try? fileManager.removeItem(at: path)
            }
        }
        return data
    }
    
    // Checks the cache and returns a publisher that emits the data or makes a network request if not found
    func imageDataSyncronizer(forKey key: String,
                               cacheAvailable: @escaping (Data) -> Void,
                               cacheNotAvailableHitAPI: @escaping () -> Void) {
        queue.sync {
            if let cachedData = fetchImageData(forKey: key) {
                // If cached data exists, wrap it in a Just publisher and return as ImageDataPublisher
                cacheAvailable(cachedData)
            } else {
                // If no cached data exists, trigger the API call
                cacheNotAvailableHitAPI()
            }
        }
    }
    
    // Clear entire cache
    func clearCache() {
        memoryCache.removeAllObjects()
        queue.async(flags: .barrier) {
            do {
                let files = try self.fileManager.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: nil)
                for file in files {
                    try self.fileManager.removeItem(at: file)
                }
            } catch {
                print("Failed to clear cache: \(error)")
            }
        }
    }
}
