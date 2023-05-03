//
//  File.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 02/05/2023.
//

import Foundation
import SwiftUI

struct BaseLesson: Codable, Hashable {
    let lessons: [Lesson]
}


struct Lesson: Hashable, Codable, Identifiable{
    var id: Int
    var name: String
    var description: String
    var video_url: String
    var thumbnail: String
    
//    var thumbnailImage: Image {
//        Image(thumbnail)
//    }
}

var mockLesson = Lesson(
    id: 950,
    name: "The Key To Success In iPhone Photography",
    description: "What’s the secret to taking truly incredible iPhone photos? Learning how to use your iPhone camera is very important, but there’s something even more fundamental to iPhone photography that will help you take the photos of your dreams! Watch this video to learn some unique photography techniques and to discover your own key to success in iPhone photography!",
    video_url: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4", thumbnail: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560"
)

var mockLessonArray = [
    Lesson(
        id: 950,
        name: "The Key To Success In iPhone Photography",
        description: "What’s the secret to taking truly incredible iPhone photos? Learning how to use your iPhone camera is very important, but there’s something even more fundamental to iPhone photography that will help you take the photos of your dreams! Watch this video to learn some unique photography techniques and to discover your own key to success in iPhone photography!",
        video_url: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
        thumbnail: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560"
    ),
    
    Lesson (
        id: 3657,
        name: "3 Secret iPhone Camera Features For Perfect Focus",
        description: "Do your photos sometimes look blurry? You're definitely not alone! Watch this video and discover a hidden iPhone camera feature for taking tack sharp photos. Using this simple feature will ensure that you never take a blurry iPhone photo again!",
        video_url: "https://embed-ssl.wistia.com/deliveries/f2cd208ce7fddf0c0ea886a8f1d0eabf26271816/2rya8a2tcw.mp4",
        thumbnail: "https://embed-ssl.wistia.com/deliveries/b9c2cec0d077d9f3d80b5f35494f4344.jpg?image_crop_resized=1000x560"
    ),
    
    Lesson (
        id: 400,
        name: "Setting The Correct Exposure For Your Photos",
        description: "Setting the correct exposure is essential for capturing stunning photos with amazing detail. But did you know that exposure can also be used as a creative tool to take truly unique images? Watch this video from our breakthrough iPhone Photo Academy course, and discover the secrets of setting the perfect exposure for your iPhone photos.",
        video_url: "https://embed-ssl.wistia.com/deliveries/e44591085be02418cbeadb8caf1e55b190d3394f/y1w5pyzd60.mp4",
        thumbnail: "https://embed-ssl.wistia.com/deliveries/fe7e9620023e9f9b63b86816c6774f8d.jpg?image_crop_resized=1000x560"
    )
]
    
