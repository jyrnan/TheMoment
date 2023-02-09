//
//  TimelineView.swift
//  DemoTabView
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct TimelineView: View {
    @Binding var path: [UUID]
    @Binding var sheet: HomeView.Sheet?

    @State var commits: [Commit] = Array(repeating: Commit.examples, count: 1).flatMap { $0 .shuffled() }
    @State var commitsCopy: [Commit] = Array(repeating: Commit.examples, count: 1).flatMap { $0 .shuffled() }

    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)

    var body: some View {
        List {
            BannerView()
                .listRowInsets(.init())

            ForEach($commits, id: \.id, editActions: .delete) { $commit in
                CommitRowView(commit: commit)
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        path.append(commit.id)
                    }
            }
            .onDelete(perform: { _ in }) // 可以使EditButton生效
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(path: .constant([]), sheet: .constant(nil))
    }
}
