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

    @State var switchTimeline: Int = 0
    @State var branches: [String] = ["Main", "Life", "Workout", "Meditation"]

    var body: some View {
        NavigationStack(path: $path) {
            TimelineView(path: $path, sheet: $sheet)
                .ignoresSafeArea(edges: .top)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .id(switchTimeline)
                .navigationTitle(branches[switchTimeline])
                .navigationDestination(for: UUID.self, destination: { id in DetailView(id: id, path: $path) })
                .toolbar {
                    HStack { // 添加 HStack
                        EditButton()
                        Button(action: { switchTimeline = switchTimeline < branches.count - 1 ? switchTimeline + 1 : 0 }) {
//                            Label("Add Item", systemImage: "plus")
                            Text("Add")
                        }
                    }
                }
        }
        .animation(.default, value: switchTimeline)
    }
}

struct BranchView_Previews: PreviewProvider {
    static var previews: some View {
        BranchScreen(sheet: .constant(nil))
    }
}
