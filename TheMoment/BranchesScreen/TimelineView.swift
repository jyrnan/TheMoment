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
        GeometryReader { proxy in
            List {
                BannerView(proxy: proxy)
                    .listRowInsets(.init())

                ForEach(posts, id: \.id) { post in
                    CommitRowView(post: post)
                        .listRowInsets(.init())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            path.append(post.id)
                        }
                        .swipeActions {
                            Button {
                                withAnimation{
                                    posts = posts.reversed()}
                            } label: {
                                Label("Reply", systemImage: "arrowshape.turn.up.left")
                            }.tint(.blue)
                            Button {
                                withAnimation{
                                    posts = posts.reversed()}
                            } label: {
                                Label("Reply", systemImage: "arrowshape.turn.up.left")
                            }.tint(.blue)
                        }
                }

//                    .background(gradient.opacity(0.25))
            }
            .listStyle(.plain)
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(path: .constant([]))
    }
}
