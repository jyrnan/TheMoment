//
//  EditCommitViewModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/18.
//

import Foundation

class EditCommitViewModel: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var text: String = ""
    
    @Published var branches:[Branch] = Branch.examples
    @Published var selectedBranch: UUID?
    
    @Published var location: String = "22.54°N, 36.38°E"
    @Published var images: [String] = ["Image", "Meat", "Banner"]
    @Published var weather: String = ["Sunny", "Cloudy", "Rain", "Storm"].randomElement() ?? "Sunny"
    
    deinit{
        print(#line, String(describing: self))
    }
    
    func addCommit() -> Bool {
        
        let commit: CD_Commit = viewContext.insertObject()
        commit.uuid = UUID()
        
        var titleAndContent = text.split(maxSplits: 1,omittingEmptySubsequences: true,  whereSeparator: {$0 == "\n"}).compactMap(String.init)
        
        if titleAndContent.count > 1 {
            commit.title = titleAndContent.first
            commit.content = titleAndContent.last
        } else {
            commit.title = titleAndContent.first
        }
        
        commit.date = .now
        commit.images = ["Meat"]
        return viewContext.saveOrRollback()
    }
}
