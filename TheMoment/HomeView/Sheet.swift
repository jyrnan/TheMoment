//
//  Sheet.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/4.
//

import SwiftUI

extension HomeView {
    enum Sheet: Identifiable, View {
        case newCommit
        case editCommit(CD_Commit)
        case newBranch
        case editBranch(CD_Branch)
        
        var id: UUID {
            switch self {
            case .newCommit:
                return UUID()
            case .editCommit(let commit):
                return commit.uuid!
           
                
            case .newBranch:
                return UUID()
            case .editBranch(let branch):
                return branch.uuid!
            }
        }
        
        var body: some View {
            switch self {
            case .newCommit:
                EditCommitView(uuid: id)
            case .editCommit(let commit):
                EditCommitView(commit: commit)
        
            case .newBranch:
                EditBranchView(uuid: id)
            case .editBranch(let branch):
                EditBranchView(branch: branch)
            }
        }
    }
}


