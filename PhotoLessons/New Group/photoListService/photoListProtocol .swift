//
//  photoListProtocol .swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 03/05/2023.
//

import Foundation
import Combine


struct PhotoStoreResult {
    let dataType: DataType
    let movieList: [Lesson]?
    let error: Error?
}

protocol PhotoListProtocol {
    var moviesResponseSubject: PassthroughSubject<PhotoStoreResult, Error> { get }
    
    func fetchLessonsList()
}
