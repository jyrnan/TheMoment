//
//  ThumbnailRowView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/3/3.
//

import SwiftUI

struct ThumbnailRowView: View {
  
  var thumbnails: [CD_Thumbnail]
  @Binding var selectedThumbTab: CD_Thumbnail?
  var body: some View {
    ForEach(thumbnails, id: \.self) { thumbnail in
      ZStack {
        Image(uiImage: UIImage(data: thumbnail.data!) ?? UIImage(systemName: "photo")!)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .onTapGesture {
            withAnimation{
              selectedThumbTab = thumbnail}
          }
          .layoutPriority(-1)
        
        
        Color.clear
          .frame(width: 32, height: 32)
      }
      .cornerRadius(8)
      .clipped()
      .aspectRatio(contentMode: .fill)
      .border(thumbnail == selectedThumbTab ? .red : .clear, width: 2)
    }
  }
}

struct ThumbnailRowView_Previews: PreviewProvider {
    static var previews: some View {
      ThumbnailRowView(thumbnails: [], selectedThumbTab: .constant(nil))
    }
}
