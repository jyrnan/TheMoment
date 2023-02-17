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
            
            makeInfoView()
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
    
    private func makeInfoView() -> some View {
        
        HStack(spacing: 0) {
            HStack(spacing: 0){
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: 2)
                    .padding(.leading, Dim.leftSpace)
                    .padding(.trailing, Dim.rightSpace)
                    .frame(width: Dim.leftSpace + Dim.rightSpace + 2, alignment: .leading)
                (Text("... 232 ").bold() + Text("Days ") + Text("2344 ").bold() + Text("Commits ") + Text("2555 ").bold() + Text("Photos"))
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        BranchView(sheet: .constant(nil), path: .constant([]), selectedBranch: .constant(0), branch: Branch(), branchCount: 4)
    }
}
