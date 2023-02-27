//
//  EditCommitViewModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/18.
//

import Foundation
import CoreData

class EditCommitViewModel: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    var commit: CD_Commit?
    
    @Published var title: String = ""
    @Published var content: String = ""
    
    @Published var branches:[Branch] = Branch.examples
    @Published var selectedBranch: CD_Branch?

    @Published var location: String = "22.54°N, 36.38°E"
    @Published var images: [String] = ["Image", "Meat", "Banner"]
    @Published var weather: String = ["Sunny", "Cloudy", "Rain", "Storm"].randomElement() ?? "Sunny"
    
    init(commit: CD_Commit?) {
        self.title = commit?.title ?? ""
        self.content = commit?.content ?? ""
    }
    
    deinit{
        print(#line, String(describing: self))
    }
    
    func newCommit(uuid: UUID) -> CD_Commit {
        let commit: CD_Commit = viewContext.insertObject()
        commit.uuid = uuid
        // 创建时间在首次创建进行修改
        updateDate(commit: commit, date: .now)
        return commit
    }
    
    func updateAndSave(commit: CD_Commit) -> Bool {
        commit.title = title.count > 0 ? title : nil
        commit.content = content.count > 0 ? content : nil
        
        commit.branch = selectedBranch
        
        commit.editAt = .now
//        commit.images = images
        
        return viewContext.saveOrRollback()
    }
    
    func delete(commit: CD_Commit) -> Bool {
        viewContext.delete(commit)
        return viewContext.saveOrRollback()
    }
    
    func updateDate(commit: CD_Commit, date: Date) {
        commit.date = date
    }
}
