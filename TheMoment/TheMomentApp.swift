//
//  TheMomentApp.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import LocalAuthentication
import SwiftUI
import CoreData

@main
struct TheMomentApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) private var scenePhase
    
    /// An authentication context stored at class scope so it's available for use during UI updates.
    @State var context = LAContext()
    @State var authState = AuthenticationState.loggedout
    
    init() {
        checkInitialBranch()
    }

    var body: some Scene {
        WindowGroup {
                HomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .overlay{
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
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

extension TheMomentApp {
    private func checkInitialBranch() {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let sortDescriptor = NSSortDescriptor.init(key: #keyPath(CD_Branch.date), ascending: true)
        let request = NSFetchRequest<NSManagedObject>(entityName: "CD_Branch")
        request.sortDescriptors = [sortDescriptor]
        
        do {
            var result = try viewContext.fetch(request)
            guard !result.isEmpty else {return createInitialBranch(context: viewContext)}
            
            result = result.filter{
                if let branch = $0 as? CD_Branch, branch.name == "Moment", branch.initial == true {
                    return true
                }
                return false
            }
            
            if !result.dropFirst().isEmpty {
                result.forEach{
                    viewContext.delete($0)
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    private func createInitialBranch(context: NSManagedObjectContext) {
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
    }
}
