//
//  CacheType.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 06/05/2023.
//

import Foundation
import Combine


protocol CachedType {
    
   // var requestTimeOut: Float { get }
    
    typealias Headers = [String: Any]
        
        func cachedGet<T>(type: T.Type,
                    endpoint: Endpoint,
                    headers: Headers,
                    decoder: JSONDecoder
        ) -> AnyPublisher<T, Error> where T: Decodable
    
}
