//
//  BranchesView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import CoreData
import SwiftUI

struct BranchScreen: View {
    @State var path: [UUID] = []

    @Binding var sheet: HomeView.Sheet?

    @State var selectedBranch: UUID = UUID()

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.name, ascending: false)],
        animation: .default)
    private var branches: FetchedResults<CD_Branch>

    var body: some View {
        NavigationStack(path: $path) {
            BranchView(sheet: $sheet,
                       path: $path,
                       selectedBranch: $selectedBranch,
//                       branch: getCurrentBranch(),
                       branchCount: branches.count)
//                .ignoresSafeArea(edges: .top)
//                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
//                .id(selectedBranch)
//                .navigationTitle("Moment")
//                .navigationDestination(for: UUID.self, destination: { id in DetailView(id: id, path: $path) })
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
////                            selectedBranch = selectedBranch < branches.count - 1 ? selectedBranch + 1 : 0
//
//                        } label: {
//                            Text("Switch")
//                                .foregroundColor(.white)
//                                .contextMenu {
//                                    ForEach(branches) { branch in
//                                        Button {
//                                            
//                                        } label: {
//                                            Text(branch.name ?? "Moment")
//                                        }
//                                    }
//                                }
//                        }
//                    }
//                    ToolbarItemGroup(placement: .secondaryAction) {
//                        ForEach(branches) { branch in
//
//                            // 这里面似乎只能放Button类型的View
//                            Button {
//                                selectedBranch = branch.uuid!
//                            } label: {
//                                Text(branch.name ?? "Moment")
//                            }
//                        }
//                        Button {
//                            sheet = .editBranch(getCurrentBranch())
//                        } label: {
//                            Text("Edit Current")
//                        }
//
//                        Button {
//                            sheet = .newBranch
//                        } label: {
//                            Text("New Branch")
//                        }
//                    }
//                }
//                .animation(.default, value: selectedBranch)
//                .tint(branches[selectedBranch].accentColor)
        }
    }

    private func getCurrentBranch() -> CD_Branch {
        guard !branches.isEmpty else {
            let branch: CD_Branch = viewContext.insertObject()
            branch.name = "Moment"
            branch.uuid = UUID()
            return branch
        }
        return branches.filter{$0.uuid == selectedBranch}.first ?? branches.first!
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
        BranchScreen(sheet: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
