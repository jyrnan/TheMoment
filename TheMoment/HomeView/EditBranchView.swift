//
//  EditBranchView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//

import SwiftUI

struct EditBranchView: View {
    @StateObject var vm: EditBranchViewModel = .init()
    
    @Environment(\.dismiss) var dissmiss
    
    var branch: CD_Branch?
    var uuid: UUID?
    
    var isEditMode: Bool { branch != nil}
    
    var body: some View {
        VStack {
            Form {
                Section(content: { TextEditor(text: $vm.name)
                        .frame(maxHeight: 200)
                }, header: { Text("Input some words below") }, footer: {
                    
                })
            }
  
            VStack{
                Button {
                    if isEditMode {
                        guard vm.updateAndSave(branch: branch!) else {return}
                        dissmiss()
                    } else {
                        let newBranch = vm.newBranch(uuid: uuid ?? UUID())
                        guard vm.updateAndSave(branch: newBranch) else {return}
                        dissmiss()
                    }
                    
                } label: {
                    Text(isEditMode ? "Save Branch" : "New Branch")
                }
                .padding()
                .tint(.accentColor)
                .disabled(vm.name == "")
                
                if isEditMode {
                    Button {
                            guard vm.delete(branch: branch!) else {return}
                            dissmiss()
                    } label: {
                        Text("Delete Branch")
                    }
                    .padding()
                    
                }
                
            }
            
        }
    }
}

struct EditBranchView_Previews: PreviewProvider {
    static var previews: some View {
        EditBranchView()
    }
}
