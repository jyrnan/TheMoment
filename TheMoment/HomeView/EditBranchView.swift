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
                Section(content: { TextField("Branch Name", text: $vm.name)
                        .frame(maxHeight: 200)
                }, header: { Text("Branch Name") }, footer: {
                    
                })
                
                Picker("Branch Color", selection: $vm.selectedColor) {
                    ForEach(CD_Branch.BranchColor.allCases, id: \.rawValue) { color in
                        Text(color.rawValue)
//                        Label(color.rawValue, systemImage: "folder")
                            .tag(color.rawValue)
                    }
                }
//                .pickerStyle(.segmented)
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
                    Button(role: .destructive, action: { guard vm.delete(branch: branch!) else {return}
                        dissmiss()
                        
                    }, label: {Text("Delete Branch")})
                    .padding()

                }
                
            }
            
        }
        .onAppear{
            vm.selectedColor = branch?.accentColor ?? "system"
            vm.name = branch?.name ?? ""
            
            // 这段代码用来定制Picker在segement模式下的颜色
            UISegmentedControl.appearance().selectedSegmentTintColor = .red
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemYellow], for: .normal)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        }
    }
}

struct EditBranchView_Previews: PreviewProvider {
    static var previews: some View {
        EditBranchView(branch: CD_Branch(context: PersistenceController.shared.container.viewContext))
    }
}
