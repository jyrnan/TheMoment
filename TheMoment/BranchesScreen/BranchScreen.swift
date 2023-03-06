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
    @Binding var currentBranch: CD_Branch

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.date, ascending: true)],
        animation: .default)
    private var branches: FetchedResults<CD_Branch>

    var body: some View {
        NavigationStack(path: $path) {
            BranchView(sheet: $sheet,
                       path: $path,
                       currentBranch: $currentBranch,
                       branchCount: branches.count)
                .ignoresSafeArea(edges: .top)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                .id(currentBranch)
                .navigationTitle(currentBranch.name ?? "Moment")
                .navigationDestination(for: CD_Commit.self, destination: { commit in EditCommitView(viewModel: EditCommitViewModel(commit: commit)) })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            switchToNextBranch()
                        } label: {
                          Image(systemName: "arrow.left.arrow.right").font(.body)
                        }
                    }

                    ToolbarItemGroup(placement: .secondaryAction) {
                        ForEach(branches) { branch in

                            // 这里面似乎只能放Button类型的View
                            Button {
                                currentBranch = branch
                            } label: {
                              Label(branch.name ?? "Moment", systemImage: "checkmark")
                            }
                            .labelStyle(TitleOnlyLabelStyle())
                        }

                        Button {
                            sheet = .editBranch(currentBranch)
                        } label: {
                            Label("Edit Current", systemImage: "pencil")
                        }

                        Button {
                            sheet = .newBranch
                        } label: {
                            Label("New Branch", systemImage: "plus").labelStyle(DefaultLabelStyle())
                        }
                    }
                }
                .animation(.default, value: currentBranch)
                .tint(currentBranch.color)
        }
    }
    
    private func switchToNextBranch(){
      if let currentIndex = branches.firstIndex(of: currentBranch),
         branches.index(after: currentIndex) != branches.endIndex  {
        currentBranch = branches[branches.index(after: currentIndex)]
      } else {
        currentBranch = branches.first!
      }
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
      BranchScreen(sheet: .constant(nil), currentBranch: .constant(CD_Branch.sample))
    }
}
