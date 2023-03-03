//
//  BranchesView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import CoreData
import SwiftUI

struct BranchScreen: View {
    @State var path: [CD_Commit] = []

    @Binding var sheet: HomeView.Sheet?

    @State var selectedBranch: UUID?

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.date, ascending: true)],
        animation: .default)
    private var branches: FetchedResults<CD_Branch>

    var body: some View {
        NavigationStack(path: $path) {
            BranchView(sheet: $sheet,
                       path: $path,
                       selectedBranch: $selectedBranch,
                       branch: getCurrentBranch(),
                       branchCount: branches.count)
                .ignoresSafeArea(edges: .top)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                .id(selectedBranch)
                .navigationTitle(getCurrentBranch().name ?? "Moment")
                .navigationDestination(for: CD_Commit.self, destination: { commit in EditCommitView(commit: commit) })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            switchToNextBranch()
                        } label: {
                            Text("Switch")
                        }
                    }
                    
                    ToolbarItemGroup(placement: .secondaryAction) {
                        ForEach(branches) { branch in

                            // 这里面似乎只能放Button类型的View
                            Button {
                                selectedBranch = branch.uuid
                            } label: {
                                Label(branch.name ?? "Moment", systemImage: branch.uuid == selectedBranch ? "checkmark" : "")
                            }
                        }
                        
                        Button {
                            sheet = .editBranch(getCurrentBranch())
                        } label: {
                            Label("Edit Current", systemImage: "pencil")
                        }

                        Button {
                            sheet = .newBranch
                        } label: {
//                            Text("New Branch")
                            Label("New Branch", systemImage: "plus").labelStyle(DefaultLabelStyle())
                        }
                    }
                }
                .animation(.default, value: selectedBranch)
                .tint(getCurrentBranch().color)
        }
    }

    private func getCurrentBranch() -> CD_Branch {
        guard !branches.isEmpty else {
            fatalError("No Branch")
        }

        guard selectedBranch != nil,
              let branch = branches.filter({ $0.uuid == selectedBranch }).first else { return branches.first! }
        return branch
    }
    
    private func switchToNextBranch(){
        guard branches.count > 1 else {return}
        
        if selectedBranch == nil {
            selectedBranch = branches.first?.uuid
            switchToNextBranch()
        }
        
        let uuidArray = branches.map(\.uuid)
        
        if selectedBranch == uuidArray.last {
            selectedBranch = uuidArray.first!
        } else {
            if let currentIndex = uuidArray.firstIndex(of: selectedBranch){
                let nextIndex = uuidArray.index(after: currentIndex)
                selectedBranch = uuidArray[nextIndex]
            }
            
        }
        
        
        
        
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
        BranchScreen(sheet: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
