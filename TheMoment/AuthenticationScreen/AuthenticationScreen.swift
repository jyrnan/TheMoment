//
//  AuthenticationScreen.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/16.
//

import LocalAuthentication
import SwiftUI

struct AuthenticationScreen: View {
    /// An authentication context stored at class scope so it's available for use during UI updates.
    @Binding var context: LAContext

    @Binding var state: TheMomentApp.AuthenticationState
    
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Button {
                    authByFaceid()
                } label: {
                    Image(systemName: "faceid").font(.title)
                }
                .buttonStyle(.bordered)
                .padding(.bottom, 50)
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .background(Color(.darkGray))
            .ignoresSafeArea(.all)
            .opacity(state == .loggedin ? 0 : 1)
            .transition(.move(edge: .top))
            .id(state)
            .animation(.default, value: state)
            
            VStack {
                HStack {
                    TextField("Input password", text: $password)
                        .padding(8)
                    Button {
                        state = .loggedin
                    } label: {
                        Image(systemName: "arrow.right.circle").font(.title)
                    }.padding(0)
                }
                .background(Capsule().fill(.ultraThinMaterial))
                .padding(.horizontal, 80)
                .padding(.top, 40)
                
            
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color(.darkGray).ignoresSafeArea())
            .opacity(state == .loggedin ? 0 : 1)
            .transition(.move(edge: .bottom))
            .id(state)
            .animation(.default, value: state)
        }
    }

    private func authByFaceid() {
        // Get a fresh context for each login. If you use the same context on multiple attempts
        //  (by commenting out the next line), then a previously successful authentication
        //  causes the next policy evaluation to succeed without testing biometry again.
        //  That's usually not what you want.
        context = LAContext()

        context.localizedCancelTitle = "Enter Username/Password"

        // First check if we have the needed hardware support.
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            print(error?.localizedDescription ?? "Can't evaluate policy")

            // Fall back to a asking for username and password.
            // ...
            return
        }
        Task {
            do {
                try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account")
                withAnimation {
                    state = .loggedin
                }
            } catch {
                print(error.localizedDescription)

                // Fall back to a asking for username and password.
                // ...
            }
        }
    }
}

struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen(context: .constant(LAContext()), state: .constant(.loggedout))
    }
}

extension AuthenticationScreen {
    enum AuthType {
        case face
        case password
    }
}
