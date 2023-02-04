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
    let logoRadius: CGFloat = 32
    
    var proxy: GeometryProxy
    var body: some View {
        Image("Banner")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
//                width: UIScreen.main.bounds.size.width,
                width: proxy.size.width,
                height: 240)
            .overlay{
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: Dim.lineWidth, height: lineLength)
                    .padding(.leading, Dim.leftSpace)
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomLeading)
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: dotRadius * 2, height: dotRadius * 2)
                    .padding(.leading, Dim.leftSpace + Dim.lineWidth / 2 - dotRadius)
                    .padding(.bottom, lineLength - dotRadius)
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomLeading)
                
                Circle()
                    .foregroundColor(.accentColor)
                    .overlay{
                        Image(systemName: "house").font(.title).foregroundColor(.white)
                    }
                    .frame(width: logoRadius * 2, height: logoRadius * 2)
                    .padding(.leading, Dim.leftSpace + Dim.lineWidth / 2 - logoRadius)
                    .padding(.bottom, lineLength + dotRadius * 2)
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomLeading)
                    
                    
                    
            }
    }
        
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {proxy in
            BannerView(proxy: proxy)
        }
        
    }
}
