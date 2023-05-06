//
//  Endpoint.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 03/05/2023.
//

import Foundation

protocol Endpoint {
    func createUrl() -> URLRequest
}

struct Endpoints {
    private init() {}
    
    struct Lessons: Endpoint {
        private var path: String { "test-api" }
        
        private var path2: String { "lessons" }
     
//        let page: Int
//        let path2: Int
//
//        init(page: Int, category: Category) {
//            self.page = page
//            self.category = category
//        }
        
        func createUrl() -> URLRequest {
            return URLRequest(httpMethod: .get, path: "\(path)/\(path2)", timeOut: 60.0, cache: .returnCacheDataElseLoad)//, queries: ["page": page])
        }
    }
    
    
    
    
    struct LessonDetails: Endpoint {
        private var path: String { "movie" }
        
        let movieId: String
                
        func createUrl() -> URLRequest {
            return URLRequest(httpMethod: .get , path: "\(path)/\(movieId)", timeOut: 60.0, cache: .reloadIgnoringLocalCacheData)
        }
    }

}
