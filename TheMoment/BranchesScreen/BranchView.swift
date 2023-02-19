//
//  BranchView.swift
//  DemoTabView
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct BranchView: View {
    
    @Binding var sheet: HomeView.Sheet?

    @Binding var path:[UUID]
    
    @Binding var selectedBranch: UUID
    var branch: CD_Branch
    var branchCount: Int
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Commit.date, ascending: false)],
        animation: .default)
    private var cd_Commits: FetchedResults<CD_Commit>

    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)

    var body: some View {
        List {
//            BannerView(selectedBranch: $selectedBranch, branch: branch, branchCount: branchCount)
//                .listRowInsets(.init())
//            
//            makeInfoView()
//                .listRowInsets(.init())
//
//            ForEach(cd_Commits, id: \.id) { commit in
//                CommitRowView(commit: commit)
//                    .listRowInsets(.init())
//                    .listRowSeparator(.hidden)
//                    .onTapGesture {
//                        path.append(commit.uuid!)
//                    }
//            }
//            .onDelete(perform: {index in
//                deleteItems(offsets: index)
//            }) // 可以使EditButton生效
            
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { cd_Commits[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static let viewContext = PersistenceController.shared.container.viewContext
    static var previews: some View {
        BranchView(sheet: .constant(nil), path: .constant([]), selectedBranch: .constant(UUID()),
                   branch: CD_Branch(context: viewContext),
                   branchCount: 4)
//        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
