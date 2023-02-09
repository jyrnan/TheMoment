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
                    
                }
                .tag("Add")

            Text("Share")
                .tabItem {
                    Label("Media", systemImage: "square.on.square.dashed")
                }
                .tag("Media")

            Text("Setting")
                .tabItem {
                    Label("Setting", systemImage: "gear")
                }
                .tag("Setting")
        }
        .overlay{
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color(.label).opacity(0.5), .ultraThinMaterial)
                .frame(width: 40, height: 44)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .onTapGesture {
                    sheet = .newCommit({_ in})
                }
        }
        .sheet(item: $sheet, content: {$0})
        .onAppear{
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
