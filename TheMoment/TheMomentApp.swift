//
//  TheMomentApp.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import LocalAuthentication
import SwiftUI

@main
struct TheMomentApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) private var scenePhase
    
    /// An authentication context stored at class scope so it's available for use during UI updates.
    @State var context = LAContext()
    @State var authState = AuthenticationState.loggedout

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
