//
//  BannerView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/4.
//

import SwiftUI

struct BannerView: View {
    let lineLength: CGFloat = 16
    let dotRadius = Dim.dotRadius + 2
    let avatarRadius: CGFloat = 32
    let gapInDotAndAvatar: CGFloat = 4
    let viewHeight: CGFloat = 240
    
    @State var avatarImage: String = "Avatar"
    @State var bannerImage: String = "Banner"
    
    var body: some View {
        ZStack {
            Image(bannerImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .layoutPriority(-1)
                .onTapGesture {
                    withAnimation{
                        bannerImage = ["Banner", "Image", "Meat"].randomElement() ?? "Banner"
                    }
                }
                
            VStack(alignment: .center, spacing: 0) {
                Circle()
                    .overlay {
                        Image(avatarImage)
                            .resizable()
                            .clipShape(Circle().inset(by: 3))
                    }
                    .frame(width: avatarRadius * 2, height: avatarRadius * 2)
                    .padding(.bottom, gapInDotAndAvatar)
                   

                Circle()
                    .frame(width: dotRadius * 2, height: dotRadius * 2)
           
                Rectangle()
                    .frame(width: Dim.lineWidth, height: lineLength)
            }
            .foregroundColor(.accentColor)
            .frame(width: Dim.leftSpace + Dim.lineWidth + Dim.leftSpace,
                   height: lineLength + dotRadius * 2 + gapInDotAndAvatar + avatarRadius * 2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .layoutPriority(-1)
            
            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .padding(.bottom, lineLength / 3)
                .padding(.leading, Dim.leftSpace * 1.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .layoutPriority(-1)
            
            Color.clear
                .frame(height: viewHeight)
        }
        .clipped()
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}
