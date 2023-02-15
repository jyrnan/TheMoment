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
    
    @Binding var selectedBranch: Int
    var branch: Branch
    var branchCount:Int
    
    @ViewBuilder
    private func makeScrollBar(currentIndex: Int, total:Int) -> some View {
        Rectangle()
            .fill(.white.opacity(0.1))
            .frame(height: 4)
            .overlay{GeometryReader {proxy in
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: proxy.size.width / CGFloat(total))
                    .position(x:proxy.size.width / CGFloat(total) * ( CGFloat(currentIndex) + 0.5 ), y: 2)
            }}
    }
        
    var body: some View {
        ZStack {
            Image(branch.bannerBGImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .layoutPriority(-1)
            
            makeScrollBar(currentIndex: selectedBranch, total: branchCount)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .layoutPriority(-1)
                
            VStack(alignment: .center, spacing: 0) {
                Circle()
                    .overlay {
                        Image(branch.avatar)
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
            
            Image(systemName: "mail.stack") // arrow.left.arrow.right.circle"
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .layoutPriority(-1)
                .contextMenu{
                    ForEach(0..<4) {int in
                        Button(action: {
                            selectedBranch = int
                        }, label: {
                            Text("Branch")
                        })
                        .buttonStyle(.bordered)
                    }
                }
                .onTapGesture {
                    selectedBranch = selectedBranch < branchCount - 1 ? selectedBranch + 1 : 0
                }
            
            Color.clear
                .frame(height: viewHeight)
        }
        .clipped()
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView(selectedBranch: .constant(0), branch: Branch(), branchCount: 4)
    }
}
