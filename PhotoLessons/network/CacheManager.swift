//
//  CacheManger.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 05/05/2023.
//

import Foundation
import Combine

class CacheManager: CachedType {
    static let sharedInstance = CacheManager()
    

    
    func cachedGet<T: Decodable>(type: T.Type, endpoint: Endpoint, headers: Headers, decoder: JSONDecoder) -> AnyPublisher<T, Error> {
        
        var urlRequest = endpoint.createUrl()
        headers.forEach { (key, value) in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest)
        if let cachedData = cachedResponse?.data,
           let cachedObject = try? decoder.decode(T.self, from: cachedData),
           let httpResponse = cachedResponse?.response as? HTTPURLResponse,
           let eTag = httpResponse.allHeaderFields["Etag"] as? String {
            // Check if the cached data is stale.
            let headers = ["If-None-Match": eTag]
            var request = endpoint.createUrl()
            request.allHTTPHeaderFields = headers
            return URLSession.shared.dataTaskPublisher(for: request)
                .mapError { _ in NetworkError.invalidRequest }
                .tryMap { (apiResponse) -> T in
                    if let httpResponse = apiResponse.response as? HTTPURLResponse, httpResponse.statusCode == 304 {
                        // The cached data is still valid, use it.
                        return cachedObject
                    } else {
                        // The cached data is stale, update the cache and use the new data.
                        let newCachedResponse = CachedURLResponse(response: apiResponse.response, data: apiResponse.data, userInfo: ["CachedDate": Date()], storagePolicy: .allowed)
                        URLCache.shared.storeCachedResponse(newCachedResponse, for: request)
                        return try decoder.decode(T.self, from: apiResponse.data)
                    }
                }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            // Fetch new data from the server since there is no cached data.
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .mapError { _ in NetworkError.invalidRequest }
                .tryMap { (apiResponse) -> T in
                    if let httpResponse = apiResponse.response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        let newCachedResponse = CachedURLResponse(response: httpResponse, data: apiResponse.data, userInfo: ["CachedDate": Date()], storagePolicy: .allowed)
                        URLCache.shared.storeCachedResponse(newCachedResponse, for: urlRequest)
                        return try decoder.decode(T.self, from: apiResponse.data)
                    } else {
                        throw NetworkError.decodeError("Failed to decode response.")
                    }
                }
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}
