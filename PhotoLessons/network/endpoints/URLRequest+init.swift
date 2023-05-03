//
//  URLRequest+init.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 03/05/2023.
//

import Foundation


extension URLRequest {
    
    init(httpMethod: HTTPRequestMethod, path: String, queries: [String: Any] = [:]) {
        
        var urlQueryItems = [URLQueryItem(name: "api_key", value: Constants.API.apiKey)]
        
        for query in queries {
            urlQueryItems.append(URLQueryItem(name: query.key, value: "\(query.value)"))
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.API.baseUrl
        components.path = "/\(Constants.API.version)/\(path)"
        components.queryItems = urlQueryItems
        let url = components.url!
        
        print("url \(url)")
        self.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        self.httpMethod = httpMethod.rawValue
    }
}
