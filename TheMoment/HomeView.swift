//
//  HomeView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab: String = "Branch"
    @State var sheet: Sheet?

    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    var body: some View {
        TabView(selection: $selectedTab) {
            BranchScreen(sheet: $sheet)
                .tabItem {
                    Label("", systemImage: "arrow.triangle.branch")
//                    Image(systemName: "arrow.triangle.branch")
                }
                .tag("Branch")

            ZStack {
                gradient
                    .opacity(0.25)
                Text("Search")
            }
            .tabItem {
                Label("", systemImage: "magnifyingglass")
            }
            .tag("Search")

            Text("Add")
                .tabItem {
                    Image(systemName: "plus")
                        .font(.system(size: 80))
                    
                }
                .tag("Add")

            Text("Share")
                .tabItem {
                    Label("", systemImage: "square.and.arrow.up")
                }
                .tag("Share")

            Text("Setting")
                .tabItem {
                    Label("", systemImage: "gear")
                }
                .tag("Setting")
        }
        .sheet(item: $sheet, content: {$0})
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
