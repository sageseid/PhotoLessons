//
//  NetworkingTest.swift
//  PhotoLessonsTests
//
//  Created by Noel Obaseki on 21/05/2023.
//

import XCTest
@testable import PhotoLessons

final class NetworkingTest: XCTestCase {
    private var destinationUrl: URL?
    private var lessons: [Lesson]?
    
    override func setUpWithError() throws {
        lessons = mockLessonArray
        destinationUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("downloadVideoTest.mp4")
    }

    override func tearDownWithError() throws {
        lessons = nil
        destinationUrl = nil
    }

    func testDownloadVideoExample() async throws {
        if(FileManager().fileExists(atPath: destinationUrl!.path)){
            print("File already exists")
        }else{
            let url = URL(string: lessons![0].video_url)!
            
            let dataAndResponse: (data: Data, response: URLResponse) = try await URLSession.shared.data(from: url, delegate: nil)
            
            let httpResponse = try XCTUnwrap(dataAndResponse.response as? HTTPURLResponse, "Expected an HTTPURLResponse.")
            XCTAssertEqual(httpResponse.statusCode, 200, "Expected a 200 OK response.")
            
            do{
                print("Start write video to local")
                try dataAndResponse.data.write(to: destinationUrl!, options: .atomic)
            }catch{
                XCTAssertThrowsError("write video to local error")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
