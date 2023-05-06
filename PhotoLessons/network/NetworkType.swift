//
//  NetworkType.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 03/05/2023.
//

import Foundation
import Combine


protocol NetworkType {
    
   // var requestTimeOut: Float { get }
    
    typealias Headers = [String: Any]
        
        func get<T>(type: T.Type,
                    endpoint: Endpoint,
                    headers: Headers,
                    decoder: JSONDecoder
        ) -> AnyPublisher<T, Error> where T: Decodable
    
}
