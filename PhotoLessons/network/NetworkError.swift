//
//  NetworkError.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 03/05/2023.
//

import Foundation

enum NetworkError: Error {
    case networkFailureError(String)
    case apiErrorResponse([String: Any])
    case decodeError(String)
    case invalidRequest
    case dataLoadingError(statusCode: Int, data: Data)
}
