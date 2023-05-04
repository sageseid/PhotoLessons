//
//  PhotoListService.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 03/05/2023.
//

import Foundation

import Combine

final class PhotoListService: PhotoListProtocol {
    private let networkManager: NetworkType
    
    var photosResponseSubject: PassthroughSubject<PhotoStoreResult, Error>
    
    private var cancellableSet: Set<AnyCancellable> = []

    init( networkManager: NetworkType = NetworkManager.sharedInstance) {
        self.networkManager = networkManager
    }

    func apiFailureHandler(error: Error) {
           let request = URLRequest(url: URL(string: "https://example.com")!) // Replace with your actual URL
           if let cachedResponse =  URLCache.shared.cachedResponse(for: request) {
               let datax = cachedResponse.data
               // TODO: Display cached response data
//               self.photosResponseSubject.send(PhotoStoreResult(dataType: .cached , lessonList: datax, error: error))
           } else {
               self.photosResponseSubject.send(PhotoStoreResult(dataType: .noData , lessonList: [], error: error))
                               }
    }
    
    func getLessons() -> AnyPublisher<[Lesson], Error> {
            let url = URL(string: "https://iphonephotographyschool.com/test-api/lessons")!
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            
            if let cachedResponse = cache.cachedResponse(for: request),
               let cachedData = cachedResponse.data,
               let cachedLessonResponse = try? decoder.decode(LessonResponse.self, from: cachedData) {
                return Just(cachedLessonResponse.lessons)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            return session.dataTaskPublisher(for: request)
                .tryMap { data, response -> LessonResponse in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw NetworkError.invalidResponse
                    }
                    guard let lessonResponse = try? self.decoder.decode(LessonResponse.self, from: data) else {
                        throw NetworkError.dataNotFound
                    }
                    
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    self.cache.storeCachedResponse(cachedResponse, for: request)
                    
                    return lessonResponse
                }
                .map { $0.lessons }
                .eraseToAnyPublisher()
        }
    
    func fetchLessonsList() {
        let endpoint = Endpoints.Lessons()
        let decoder = JSONDecoder()
        let headers = [ "Cache-Control": "max-age=120"]
       // let headers = [ "Cache-Control": "max-age=1800, no-cache"]
        
        let networkCallPublisher: AnyPublisher<BaseLesson, Error> = networkManager.get(type: BaseLesson.self, endpoint: endpoint, headers: [:], decoder: decoder)
        
        
        networkCallPublisher.sink {
            (completion) in
            switch completion {
            case .finished: break
            case .failure(let error):
                 self.apiFailureHandler(error: error)
            }
        } receiveValue: { [weak self] (baselessons) in
            
            self?.photosResponseSubject.send(PhotoStoreResult(dataType: .live , lessonList: baselessons.lessons, error: nil))
                 
           
         }.store(in: &cancellableSet)
        
    }
    
    
    
}
