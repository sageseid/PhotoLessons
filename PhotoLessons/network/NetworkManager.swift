//
//  NetworkManager.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 03/05/2023.
//

import Foundation
import Combine

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

class NetworkManager: NetworkType {
    static let sharedInstance = NetworkManager()
    
    func get<T: Decodable>(type: T.Type, endpoint: Endpoint, headers: Headers, decoder: JSONDecoder
                           ) -> AnyPublisher<T, Error>  {
        
        var urlRequest = endpoint.createUrl()
        //URLRequest(url: url)
        headers.forEach { (key, value) in
                    if let value = value as? String {
                        urlRequest.setValue(value, forHTTPHeaderField: key)
                    }
                }
      
        
      return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { _ in NetworkError.invalidRequest }
            .tryMap({ (apiResponse) -> T in
                do {
                    return try decoder.decode(T.self, from: apiResponse.data)
                }catch {
                    throw NetworkError.decodeError("Failed to decode response: \(error.localizedDescription)")
                }
            })  .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
        
    


}

func loadData(url: URL) -> AnyPublisher<[Lesson], Error> {
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
    
    return URLSession.shared
        .dataTaskPublisher(for: request)
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            if httpResponse.statusCode == 304 {
                // Data is in cache, return cached data
                if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
                    return cachedResponse.data
                } else {
                    throw URLError(.badServerResponse)
                }
            } else if httpResponse.statusCode == 200 {
                // Data is not in cache, store response in cache
                let cachedResponse = CachedURLResponse(response: httpResponse, data: data, userInfo: ["CachedDate": Date()], storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                return data
            } else {
                throw URLError(.badServerResponse)
            }
        }
        .decode(type: [String:[Lesson]].self, decoder: JSONDecoder())
        .map { $0["lessons"] ?? [] }
        .eraseToAnyPublisher()
}
