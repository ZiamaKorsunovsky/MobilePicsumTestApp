//
//  CacheService.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-27.
//

import Foundation

class CacheService {

    static func setup() {
        let memoryCapacity = 20 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "PhotosCache")
        URLCache.shared = cache
    }

    static func getCachedData(for url: URL) -> Data? {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return cachedResponse.data
        }
        return nil
    }

    static func setCachedData(with response: URLResponse, request: URLRequest, data: Data) {
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
}
