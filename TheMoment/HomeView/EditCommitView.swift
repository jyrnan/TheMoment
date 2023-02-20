//
//  NewCommitView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/17.
//

import SwiftUI

struct EditCommitView: View {
    @StateObject var vm: EditCommitViewModel
    
    @Environment(\.dismiss) var dissmiss
    var uuid: UUID?
    var commit: CD_Commit?
    
    var isEditMode: Bool { commit != nil }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.name, ascending: false)],
        animation: .default)
    private var cd_Branches: FetchedResults<CD_Branch>
    
    init(uuid: UUID? = nil, commit: CD_Commit? = nil) {
        _vm = StateObject(wrappedValue: EditCommitViewModel(commit: commit))
        self.uuid = uuid
        self.commit = commit
    }
    
    var body: some View {
        VStack {
            List {
                Section(content: {
                            Picker("", selection: $vm.selectedBranch) {
                                ForEach(cd_Branches) { branch in
                                    Text(branch.name ?? "Moment")
                                        .tag(branch.uuid)
                                }
                            }
                            .padding(.horizontal)
                        },
                        header: { Text("Branch") },
                        footer: {
                            Text("Choose which branch to commit. You can also change it later")
                    
                                .font(.caption2)
                                .foregroundColor(.gray)
                        })
                .listRowInsets(.init())
                
                Section(content: {
                    TextField("Title", text: $vm.title)
                        .padding(.horizontal)
                        
                    TextEditor(text: $vm.content)
                        .padding(.horizontal)
                        .frame(height:120)
                },
                        header: { Text("Words") },
                        footer: {
                    Text("\(Image(systemName: "sun.max")) \(vm.weather) \(arc4random_uniform(25))°C")
                    
                        .font(.caption2)
                        .foregroundColor(.gray)
                }).listRowInsets(.init())
            
                if !vm.images.isEmpty {
                    Section(content: {
                                TabView{
                                    ForEach(vm.images, id: \.self) {image in
                                        Image(image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    }
                                    
                                }.frame(height: 200)
                                .tabViewStyle(.page)
                            },
                            header: { Text(vm.images.first ?? "Photo") },
                            footer: {})
                        .listRowInsets(.init())
                }
                
                Section(content: {
                            Rectangle().fill(.gray)
                                .frame(height: 200)
                        },
                        header: { Text(vm.location) },
                        footer: {})
                    .listRowInsets(.init())
            }

            Button {
                if isEditMode {
                    guard vm.updateAndSave(commit: commit!) else {return}
                    dissmiss()
                } else {
                    let newCommit = vm.newCommit(uuid: uuid!)
                    guard vm.updateAndSave(commit: newCommit) else {return}
                    dissmiss()
                }
            } label: {
                Text(isEditMode ? "Save Commit" : "Add Commit")
            }
            .padding()
            .tint(.accentColor)
            .disabled(vm.title == "")
            
            if isEditMode {
                Button(role: .destructive, action: {
                    viewContext.delete(commit!)
                    dissmiss()
                    
                }, label: { Text("Delete Commit") })
                    .padding()
            }
        }
        .onAppear{
            guard commit != nil else { return }
            vm.title = commit?.title ?? ""
            vm.content = commit?.content ?? ""
        }
    }
}

struct NewCommitView_Previews: PreviewProvider {
    static var previews: some View {
        EditCommitView(uuid: UUID(), commit: CD_Commit(context: PersistenceController.shared.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
