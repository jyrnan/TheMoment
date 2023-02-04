//
//  HomeView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab: String = "Branch"

    let gradient = LinearGradient(colors: [.orange, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    var body: some View {
        TabView(selection: $selectedTab) {
            BranchScreen()
                .tabItem {
                    Label("Branch", systemImage: "arrow.triangle.branch")
                }
                .tag("Branch")

            ZStack {
                gradient
                    .opacity(0.25)
                Text("Search")
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag("Search")

            Text("Add")
                .tabItem {
                    Image(systemName: "plus")
                        .font(.system(size: 80))
                    Text("Hello")
                }
                .tag("Add")

            Text("Share")
                .tabItem {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .tag("Share")

            Text("Setting")
                .tabItem {
                    Label("Setting", systemImage: "gear")
                }
                .tag("Setting")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
