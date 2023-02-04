//
//  CommitRowView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct CommitRowView: View {
    var post: Post
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 8 , height: 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: 29, y: 12)
                .foregroundColor(.accentColor)
            HStack {
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: 2)
                   
                    .padding(.leading, 32)
                Text("\(post.name)")
                    .frame(minHeight: CGFloat(arc4random_uniform(20) + 80))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                
                Text(post.image)
                    .font(.title)
                    .padding()
            }
        }
        .frame(maxHeight: 200)
        .border(.gray)
    }
}

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommitRowView(post: Post.examples.first!)
    }
}
