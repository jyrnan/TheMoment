//
//  BranchesView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct BranchScreen: View {
    @State var path: [UUID] = []
    
    @Binding var sheet: HomeView.Sheet?

    @State var selectedBranch: Int = 0
    var branches: [Branch] = Branch.examples

    var body: some View {
        NavigationStack(path: $path) {
            BranchView(sheet: $sheet, path: $path, selectedBranch: $selectedBranch, branch: branches[selectedBranch], branchCount: branches.count)
                .ignoresSafeArea(edges: .top)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
                .id(selectedBranch)
                .navigationTitle(branches[selectedBranch].name)
                .navigationDestination(for: UUID.self, destination: { id in DetailView(id: id, path: $path) })
                .toolbar{
                    Button{
                            selectedBranch = selectedBranch < branches.count - 1 ? selectedBranch + 1 : 0
                        
                    } label: {
                       Image(systemName: "arrow.left.arrow.right.circle") //Text("Switch")
                            .foregroundColor(.white)
                            .contextMenu{
                                ForEach(0..<branches.count) { index in
                                    Button{
                                        selectedBranch = index
                                    } label: {
                                        Text(branches[index].name)
                                    }
                                    
                                }
                                
                            }
                    }
                    
                }
                .animation(.default, value: selectedBranch)
                .tint(branches[selectedBranch].accentColor)
        }
        
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
        BranchScreen(sheet: .constant(nil))
    }
}
