//
//  TheMomentApp.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import CoreData
import LocalAuthentication
import SwiftUI

@main
struct TheMomentApp: App {
  let persistenceController = PersistenceController.shared
  @Environment(\.scenePhase) private var scenePhase
    
  /// An authentication context stored at class scope so it's available for use during UI updates.
  @State var context = LAContext()
  @State var authState = AuthenticationState.loggedout
    
  init() {
//    checkInitialBranch()
  }

  var body: some Scene {
    WindowGroup {
      HomeView(currentBranch: checkInitialBranch())
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .overlay {
          AuthenticationScreen(context: $context, state: $authState)
        }
    }
    .onChange(of: scenePhase, perform: { newScenePhase in
      if newScenePhase == .background {
        authState = .loggedout
      }
    })
  }
}

extension TheMomentApp {
  enum AuthenticationState {
    case loggedin, loggedout
  }
}

struct Previews_TheMomentApp_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(currentBranch: CD_Branch())
  }
}

extension TheMomentApp {
  private func checkInitialBranch() -> CD_Branch {
    let viewContext = PersistenceController.shared.container.viewContext
        
    let sortDescriptor = NSSortDescriptor(key: #keyPath(CD_Branch.date), ascending: true)
    let predicate = NSPredicate(format: "%K == %@", #keyPath(CD_Branch.name), "Moment")
    let request = NSFetchRequest<NSManagedObject>(entityName: "CD_Branch")
    request.predicate = predicate
    request.sortDescriptors = [sortDescriptor]
        
    guard let result = try? viewContext.fetch(request), let initialBranch = result.first as? CD_Branch else { return createInitialBranch(context: viewContext) }
            
    if !result.dropFirst().isEmpty {
      result.forEach {
        viewContext.delete($0)
        do {
          try viewContext.save()
        } catch {
          print(error)
        }
      }
    }
    return initialBranch
  }
    
  private func createInitialBranch(context: NSManagedObjectContext) -> CD_Branch {
    let initialBranch = CD_Branch(context: context)
    initialBranch.date = .now
    initialBranch.initial = true
    initialBranch.name = "Moment"
    initialBranch.uuid = UUID()
        
    do {
      try context.save()
    } catch {
      print(error)
    }
    
    return initialBranch
  }
}
