//
//  NewCommitView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/17.
//

import SwiftUI

struct EditCommitView: View {
    @StateObject var vm: EditCommitViewModel = .init()
    
    @Environment(\.dismiss) var dissmiss
    var uuid: UUID?
    var commit: CD_Commit?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.name, ascending: false)],
        animation: .default)
    private var cd_Branches: FetchedResults<CD_Branch>
    
    var body: some View {
        VStack {
            Form {
                Section(content: { TextEditor(text: $vm.text)
                        .frame(maxHeight: 200)
                }, header: { Text("Input some words below") }, footer: {
                    Text("\(Image(systemName: "sun.max")) \(vm.weather) \(arc4random_uniform(25))°C")
                    
                        .font(.caption2)
                        .foregroundColor(.gray)
                })
            
                Picker("Commit to", selection: $vm.selectedBranch) {
                    ForEach(cd_Branches, id: \.id) { branch in
                        Text(branch.name ?? "Moment")
                            .tag(branch.id)
                    }
                }
                
                Section(content: {
                            Rectangle().fill(.gray)
                                .frame(height: 200)
                        },
                        header: { Text(vm.location) },
                        footer: {})
            }

            Button {
                if vm.addCommit() { dissmiss() }
            } label: {
                Text("Add Commit")
            }
            .padding()
            .tint(.accentColor)
            .disabled(vm.text == "")
            Spacer()
        }
    }
}

struct NewCommitView_Previews: PreviewProvider {
    static var previews: some View {
        EditCommitView(uuid: UUID())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
