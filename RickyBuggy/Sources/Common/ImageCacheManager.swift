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
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to access the Documents directory.")
        }
        self.cacheDirectory = documentsDirectory.appendingPathComponent("ImageCache", isDirectory: true)
        
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
    
    func storeImageData(_ data: Data, forKey key: String) throws {
        let path = filePath(forKey: key)
        
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        
        queue.async(flags: .barrier) {
            do {
                try data.write(to: path)
                try self.fileManager.setAttributes([.creationDate: Date()], ofItemAtPath: path.path)
            } catch {
                print("Failed to store image data on disk: \(error)")
            }
        }
    }
    
    func fetchImageData(forKey key: String) -> Data? {
        if let data = memoryCache.object(forKey: key as NSString) {
            return data as Data
        }
        
        let path = filePath(forKey: key)
        var data: Data? = nil
        
        queue.sync {
            guard let attributes = try? fileManager.attributesOfItem(atPath: path.path),
                  let creationDate = attributes[.creationDate] as? Date else {
                return
            }
            
            if Date().timeIntervalSince(creationDate) <= cacheExpiryDuration {
                data = try? Data(contentsOf: path)
                if let data = data {
                    self.memoryCache.setObject(data as NSData, forKey: key as NSString)
                }
            } else {
                try? fileManager.removeItem(at: path)
            }
        }
        return data
    }
    
    func imageDataSyncronizer(forKey key: String,
                               cacheAvailable: @escaping (Data) -> Void,
                               cacheNotAvailableHitAPI: @escaping () -> Void) {
        queue.sync {
            if let cachedData = fetchImageData(forKey: key) {
                cacheAvailable(cachedData)
            } else {
                cacheNotAvailableHitAPI()
            }
        }
    }
    
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
