//
//  PhotoListView.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 07/05/2023.
//

import SwiftUI

struct PhotoListView: View {
    @Environment(\.colorScheme) var colorScheme
    var viewBG: Color{
        colorScheme == .dark ? Color(UIColor.systemGray5) : Color(UIColor.systemBackground)
    }
    @StateObject private var viewModel = PhotoListVM()
    //@State var lessons: [Lesson] = view
    
    //    init(){
    //        UINavigationBar.appearance().backgroundColor = UIColor.systemGray5
    //    }
    
    var body: some View{
        NavigationView {
            
            if viewModel.showNoData {
                Text("Unable to load Photos")
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(width: 50, height: 50)
            } else if viewModel.isOffline {
                    OfflineBarView()
                } 
                
                List {
                    ForEach(Array(viewModel.lessonslist.enumerated()), id: \.offset) { index, lesson in
                        // TODO: When touch the row, the background color should change
                        ZStack {
                            NavigationLink(destination: LessonDetailViewControllerWrapper(index: index, lessons: lessons)) {
                                EmptyView()
                            }
                            
                            HStack {
                                PhotoView(lesson: lesson)
                                    .padding([.top,.bottom],2)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 7)
                                    .foregroundColor(.blue)
                            }
                            .foregroundColor(Color(UIColor.label))
                        }
                    }
                }
                .listStyle(InsetListStyle())
                .padding(.top,16)
                .onAppear{}
                .navigationTitle("Lessons")
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    struct PhotoListView_Previews: PreviewProvider {
        static var previews: some View {
            PhotoListView()
        }
    }
}
