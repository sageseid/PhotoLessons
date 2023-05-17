//
//  PhotoView.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 07/05/2023.
//

// TODO: This View is available iOS 15.0.
// Should consider under 15 version user

import SwiftUI

struct PhotoView: View {
    var lesson: Lesson
    var body: some View{
        HStack {
            AsyncImage(url: URL(string:lesson.thumbnail)) { image in
                image
                    .resizable()
                    .frame(width:110,height:64)
                    .cornerRadius(6)
//                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.gray)
                    .frame(width:110,height:64)
            }

            Text(lesson.name)
                .padding([.leading, .trailing], 6)
        }
    }
}

struct PhotoView_Previews: PreviewProvider{
    
    static var previews: some View{
        PhotoView(lesson: mockLesson)
    }
}



