//
//  NetworkService.swift
//  MobilePicsumTest
//
//  Created by Artiom Rastegaev on 2024-08-27.
//

import Foundation
import UIKit

enum NetworkError: Equatable, Error {
    case emptyData, incorrectDataFormat
}

class NetworkService {

    static func fetchRandomItem(excludingIDs: [Int], completion: @escaping (Result<Photo?, Error>) -> Void) {
        DispatchQueue.global().async {
            fetchData(for: URL(string: "https://picsum.photos/v2/list")!) { data, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }

                guard let photos = try? JSONDecoder().decode([Photo].self, from: data) else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }
                let unusedPhotos = photos.filter { !excludingIDs.contains($0.id) }

                if unusedPhotos.count > 0 {
                    completion(.success(unusedPhotos.randomElement()))
                } else {
                    completion(.success(nil))
                }
            }
        }
    }

    static func loadImage(withURL imageURL: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global().async {
            fetchData(for: imageURL) { data, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }

                guard let image = UIImage(data: data) else {
                    completion(.failure(NetworkError.incorrectDataFormat))
                    return
                }

                completion(.success(image))
            }
        }
    }

    private static func fetchData(for url: URL, completion: @escaping (Data?, Error?) -> Void) {
        if let cachedData = CacheService.getCachedData(for: url) {
            // Return cached data
            completion(cachedData, nil)
        } else {
            // Fetch data from network
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let response = response {
                    // Save the response in cache
                    CacheService.setCachedData(with: response, request: request, data: data)
                }
                completion(data, error)
            }
            task.resume()
        }
    }
}
