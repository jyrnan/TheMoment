//
//  HomeView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct HomeView: View {
  @Environment(\.dismiss) var dissmiss

  @State var selectedTab: String = "Branch"
  @State var sheet: Sheet?
  @State var fullSheet: Sheet?

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

      MediaScreen(fullSheet: $fullSheet)
        .tabItem {
          Label("Media", systemImage: "square.on.square.dashed")
        }
        .tag("Media")

      Text("Add")
        .tabItem {
          Image(systemName: "plus")
            .font(.system(size: 80))
        }
        .tag("Add")
        .disabled(true)

      ZStack {
        gradient
          .opacity(0.25)
        Text("Search")
      }
      .tabItem {
        Label("Search", systemImage: "magnifyingglass")
      }
      .tag("Search")

      Text("Setting")
        .tabItem {
          Label("Setting", systemImage: "gear")
        }
        .tag("Setting")
    }
    .overlay {
      plusButtonView
        .ignoresSafeArea(.keyboard)
    }
    .sheet(item: $sheet) {
      $0.presentationDetents([.height(350), .medium, .large])
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    .sheet(item: $fullSheet) {
      $0.environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    .onAppear {
      UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    .tint(.primary)
  }

  var plusButtonView: some View {
    Image(systemName: "plus.circle.fill")
      .resizable()
      .aspectRatio(1, contentMode: .fill)
      .symbolRenderingMode(.palette)
      .foregroundStyle(Color(.label).opacity(0.5), .ultraThinMaterial)
      .frame(width: 40, height: 44)
      .frame(maxHeight: .infinity, alignment: .bottom)
      .onTapGesture {
        sheet = .newCommit
      }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
  }
}
