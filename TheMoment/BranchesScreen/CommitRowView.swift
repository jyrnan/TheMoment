//
//  CommitRowView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct CommitRowView: View {
    let leftSpace: CGFloat = Dim.leftSpace
    let lineWidth: CGFloat = Dim.lineWidth
    let dotRadius: CGFloat = Dim.dotRadius
    
    var commit: Commit

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 8 , height: 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, leftSpace + lineWidth / 2 - dotRadius)
                .padding(.top, 16)
                .foregroundColor(.accentColor)
            HStack {
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: 2)
                    .padding(.leading, leftSpace)
                Text("\(commit.name)")
                    .frame(minHeight: CGFloat(arc4random_uniform(20) + 80))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("\(commit.name)")
                    }
                
                Text(commit.image)
                    .font(.title)
                    .padding()
            }
        }
        .frame(maxHeight: 200)
//        .border(.gray)
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommitRowView(commit: Commit.examples.first!)
    }
}
