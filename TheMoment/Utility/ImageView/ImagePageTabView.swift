//
//  ImagePageTabView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/3/2.
//

import SwiftUI

struct ImagePageTabView: View {
  var thumbnails: [CD_Thumbnail]
  @State var thumbToViewed: CD_Thumbnail?
  @Binding var selectedThumbTab: CD_Thumbnail?

  var body: some View {
    TabView(selection: $selectedThumbTab) {
      ForEach(thumbnails, id: \.self) { thumbnail in
        Image(uiImage: UIImage(data: thumbnail.data!) ?? UIImage(systemName: "photo")!)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .tag(thumbnail)
          .tag(Optional(thumbnail))
          .onTapGesture {
            thumbToViewed = thumbnail
          }
          .fullScreenCover(item: $thumbToViewed) { thumbnail in
            ImageViewer(image: UIImage(data: (thumbnail.origin?.data)!)!)
          }
      }
    }
    .frame(height: 240)
    .tabViewStyle(.page)
  }
}

struct ImagePageTabView_Previews: PreviewProvider {
  static var previews: some View {
    ImagePageTabView(thumbnails: [], selectedThumbTab: .constant(nil))
  }
}
