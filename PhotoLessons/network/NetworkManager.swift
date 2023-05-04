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
