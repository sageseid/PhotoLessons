//
//  OfflineBarView.swift
//  PhotoLessons
//
//  Created by Noel Obaseki on 18/05/2023.
//

import SwiftUI

struct OfflineBarView: View {
    var body: some View {
        VStack {
            Text("Offline")
                .padding(4)
                .frame(maxWidth: .infinity)
        }
        .background(.gray)
    }

}

struct OfflineBarView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineBarView()
    }
}

