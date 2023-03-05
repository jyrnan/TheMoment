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
    
//    @Binding var selectedBranch: UUID?
    @Binding var currentBranch: CD_Branch
    var branchCount:Int
    
    @ViewBuilder
    private func makeScrollBar(currentIndex: Int, total:Int) -> some View {

        HStack(spacing: 0){
            ForEach(0..<total) {index in
                Circle()
                    .fill(currentIndex == index ? Color.accentColor : Color.white)
                    .padding(0)
                    .frame(width: 4, height: 4)
                    .padding(3)
            }
        }
        .padding(.trailing)
        
       
    }
        
    var body: some View {
        ZStack {
            Image("Banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .layoutPriority(-1)
            
            SwitchBranchView(selectedBranch: $currentBranch)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .layoutPriority(-1)
                
            VStack(alignment: .center, spacing: 0) {
                Circle()
                    .overlay {
                        Image("Avatar")
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
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.bottom, lineLength / 1)
                .padding(.leading, Dim.leftSpace * 1.8)
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
      BannerView(currentBranch: .constant(CD_Branch()), branchCount: 4)
    }
}
