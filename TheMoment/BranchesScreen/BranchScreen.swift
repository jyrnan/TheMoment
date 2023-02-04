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

    var body: some View {
        NavigationStack(path: $path) {
            TimelineView(path: $path, sheet: $sheet)
                .ignoresSafeArea(edges: .top)
                .navigationTitle("Branch")
                .navigationDestination(for: UUID.self, destination: { id in DetailView(id: id, path: $path) })
                .toolbar {
                    Button("Add", action: {})
                    EditButton()
                }
        }
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
        BranchScreen(sheet: .constant(nil))
    }
}
