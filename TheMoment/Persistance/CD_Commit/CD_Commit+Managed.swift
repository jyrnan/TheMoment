//
//  CD_Commit+Managed.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//

import CoreData
import Foundation

//extension CD_Commit: Managed {
//    
//}

extension CD_Commit {
    static func new(context: NSManagedObjectContext) -> CD_Commit {
        let commit = CD_Commit(context: context)
        commit.title = "Test"
        commit.uuid = UUID()
        commit.content = "TheMoment[3626:983176] [general] 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release"
        commit.date = Date.now
        commit.images = ["Meat"]
        
        return commit
    }
    static func noTitle(context: NSManagedObjectContext) -> CD_Commit {
        let commit = CD_Commit(context: context)
        commit.uuid = UUID()
        commit.content = "TheMoment[3626:983176] [general] 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release"
        commit.date = Date.now
        commit.images = ["Meat"]
        
        return commit
    }
}

