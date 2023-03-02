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
    case imageViewer(CD_Image)
    
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
      case .imageViewer(let image):
        return image.uuid!
      }
    }
        
    var body: some View {
      switch self {
      case .newCommit:
        EditCommitView(uuid: id, sheet: .constant(nil))
      case .editCommit(let commit):
        EditCommitView(commit: commit, sheet: .constant(nil))
                
      case .newBranch:
        EditBranchView(uuid: id)
      case .editBranch(let branch):
        EditBranchView(branch: branch)
        
      case .imageViewer(let image):
        Image(uiImage: UIImage(data: image.data!)!)
      }
    }
  }
}
