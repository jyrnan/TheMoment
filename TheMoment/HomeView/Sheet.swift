//
//  Sheet.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/4.
//

import SwiftUI

extension HomeView {
    enum Sheet: Identifiable, View {
        case newCommit((Commit) -> Void)
        case editCommit(Commit)
        case commitDetail(Commit)
        
        var id: Commit.ID {
            switch self {
            case .newCommit:
                return UUID()
            case .editCommit(let commit):
                return commit.id
            case .commitDetail(let commit):
                return commit.id
            }
        }
        
        var body: some View {
            switch self {
            case .newCommit:
                NewCommitView(id: id)
            case .editCommit(let commit):
                Text(commit.title ?? "")
            case .commitDetail(let commit):
                DetailView(id: commit.id, path: .constant([UUID()]))
            }
        }
    }
}


