//
//  BranchView.swift
//  DemoTabView
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct BranchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var sheet: HomeView.Sheet?

    @State var commits: [Commit] = Array(repeating: Commit.examples, count: 1).flatMap { $0 .shuffled() }
    @State var commitsCopy: [Commit] = Array(repeating: Commit.examples, count: 1).flatMap { $0 .shuffled() }
    
//    @EnvironmentObject var vm: BranchViewModel
    @Binding var path:[UUID]
    
    @Binding var selectedBranch: Int
    var branch: Branch
    var branchCount: Int
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)

    var body: some View {
        List {
            BannerView(selectedBranch: $selectedBranch, branch: branch, branchCount: branchCount)
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
            
            ForEach(items) { item in
                Text(item.timestamp ?? .now, format: .dateTime)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        BranchView(sheet: .constant(nil), path: .constant([]), selectedBranch: .constant(0), branch: Branch(), branchCount: 4)
    }
}
