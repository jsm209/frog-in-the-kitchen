//
//  NSCacheStorageService.swift
//  rushHour
//
//  Created by Maza, Joshua on 2/2/24.
//


import Foundation

protocol NSCacheServiceProtocol {

    /// Insert the value into cache
    /// - Parameters:
    ///   - value: value to be inserted
    ///   - key: value to be inserted for specific key.
    func insert(value: String, forKey key: NSString)

    /// Gets the value from the cache for specified key
    /// - Parameters:
    ///   - key:
    /// - Returns: The current user info model.
    func getValue(forKey key: NSString) -> String?

    /// Removed the value from the cache for specified key
    /// - Parameters:
    ///   - key:
    func removeValue(forKey key: NSString)

    /// Remove complete cache
    func removeAll()
}

extension NSCacheServiceProtocol {
    func model<T>(forKey: NSString) -> T? where T: Decodable {
        guard let responseString = getValue(forKey: forKey),
              let data = responseString.data(using: .utf8) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}

public class NSCacheStorageService: NSCacheServiceProtocol {
    private let cache = NSCache<NSString, LocalCache>()
    func insert(value: String, forKey key: NSString) {
        let localCache = LocalCache()
        localCache.value = value
        self.cache.setObject(localCache, forKey: key)
    }
    func getValue(forKey key: NSString) -> String? {
        guard let valueForKey = cache.object(forKey: key) else {
            return nil
        }
        
        guard let valueString = valueForKey.value else {
            return nil
        }
        
        return valueString as String
    }
    func removeValue(forKey key: NSString) {
        cache.removeObject(forKey: key)
    }
    func removeAll() {
        cache.removeAllObjects()
    }
}

class LocalCache: NSObject, NSDiscardableContent {
    public var value: String!

    public func beginContentAccess() -> Bool {
        return true
    }

    public func endContentAccess() { }

    public func discardContentIfPossible() { }

    public func isContentDiscarded() -> Bool {
        return false
    }
}
