//
//  PhotoListVM.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 07/05/2023.
//

import Foundation
import Combine



final class PhotoListVM: ObservableObject {
    
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var dataType: DataType = .noData
    @Published var error: Error? = nil
    @Published var lessonslist: [Lesson] = []
    @Published var isOffline = false
    @Published var showNoData = false

    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private lazy var showOfflineView: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest3(self.$dataType, self.$isLoading, self.$isRefreshing)
            .map { element in
                if element.0 == .cached, !element.1, !element.2 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }()
    
    private lazy var showNoDataLabel: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest(self.$dataType, self.$isLoading)
            .map { element in
                if element.0 == .noData, !element.1 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }()
    
    
    private let photosStore: PhotoListProtocol
    
    init(photosStore: PhotoListProtocol = PhotoListService()) {
        self.photosStore = photosStore
        photosStore.fetchLessonsList()
        showOfflineView.assign(to: &self.$isOffline)
        showNoDataLabel.assign(to: &self.$showNoData)
        
  
      
        
        bindStore()
  
    }
    
    func bindStore() {
        self.isLoading = true

        photosStore.photosResponseSubject
            .sink { [weak self] (completion) in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.error = error
                    print("error")
                }
            } receiveValue: { [weak self] (lessonsStoreResult) in
                self?.isLoading = false
                self?.isRefreshing = false
                self?.dataType = lessonsStoreResult.dataType
                print("data")
                print(lessonsStoreResult.dataType)
                self?.lessonslist = lessonsStoreResult.lessonList!
            }.store(in: &cancellableSet)
        
    }
    
    
}
