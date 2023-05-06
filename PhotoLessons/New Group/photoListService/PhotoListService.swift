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


    func fetchLessonsList() {
        let endpoint = Endpoints.Lessons()
        let decoder = JSONDecoder()
        let headers = [ "Cache-Control": "max-age=120"]
       // let headers = [ "Cache-Control": "max-age=1800, no-cache"]
        
        let networkCallPublisher: AnyPublisher<BaseLesson, Error> =
        
        networkManager.get(type: BaseLesson.self, endpoint: endpoint, headers: [:], decoder: decoder)
        
        
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
