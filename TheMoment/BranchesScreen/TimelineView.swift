//
//  TimelineView.swift
//  DemoTabView
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct TimelineView: View {
    @Binding var path: [UUID]

    @State var posts: [Post] = Post.examples

    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                BannerView()

                ForEach(posts, id: \.id) { post in
                    CommitRowView(post: post)
                        .onTapGesture {
                            path.append(post.id)
                        }
                }
            }
                .background(gradient.opacity(0.25))
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(path: .constant([]))
    }
}
