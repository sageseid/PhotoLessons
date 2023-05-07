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
    private let cacheManager: CachedType
    
    var photosResponseSubject = PassthroughSubject<PhotoStoreResult, Error>()
    
    private var cancellableSet: Set<AnyCancellable> = []

    init( networkManager: NetworkType = NetworkManager.sharedInstance, cacheManager: CachedType = CacheManager.sharedInstance) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }
    

    func apiFailureHandler(error: Error, endpoint: Endpoint) {
        let decoder = JSONDecoder()
        if let cachedResponse = URLCache.shared.cachedResponse(for: endpoint.createUrl()),
              let cachedObject = try? decoder.decode(BaseLesson.self, from: cachedResponse.data) {
               // The cached data exists, use it.
            let cachedLessons = cachedObject.lessons
            self.photosResponseSubject.send(PhotoStoreResult(dataType: .cached, lessonList: cachedLessons, error: nil))
           } else {
               // The cached data doesn't exist, do nothing.
               // print("Cached data not found.")
               self.photosResponseSubject.send(PhotoStoreResult(dataType: .noData, lessonList: [], error: nil))
           }
    }


    func fetchLessonsList() {
        let endpoint = Endpoints.Lessons()
        let decoder = JSONDecoder()
      //  let headers = [ "Cache-Control": "max-age=120"]
        
        let networkCallPublisher: AnyPublisher<BaseLesson, Error> = cacheManager.cachedGet(type: BaseLesson.self, endpoint: endpoint, headers: [:], decoder: decoder)
        
        
        networkCallPublisher.sink {
            (completion) in
            switch completion {
            case .finished: break
            case .failure(let error):
                self.apiFailureHandler(error: error , endpoint: endpoint)
            }
        } receiveValue: { [weak self] (baselessons) in
            
            self?.photosResponseSubject.send(PhotoStoreResult(dataType: .live , lessonList: baselessons.lessons, error: nil))
                 
           
         }.store(in: &cancellableSet)
        
    }
    
 
    
    
    
}
