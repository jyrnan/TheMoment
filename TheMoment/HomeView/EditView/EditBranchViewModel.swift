//
//  EditBranchViewModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//

import Foundation

class EditBranchViewModel: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var name: String = ""
    @Published var selectedColor: String = "system"
    
    func newBranch(uuid: UUID) -> CD_Branch {
        let newBranch: CD_Branch = viewContext.insertObject()
        newBranch.uuid = uuid
        
        return newBranch
    }
    
    func updateAndSave(branch: CD_Branch) -> Bool {
        
        branch.name = name
        branch.accentColor = selectedColor
        branch.date = .now
        return viewContext.saveOrRollback()
    }
    
    func delete(branch: CD_Branch) -> Bool {
        viewContext.delete(branch)
        return viewContext.saveOrRollback()
    }
}
