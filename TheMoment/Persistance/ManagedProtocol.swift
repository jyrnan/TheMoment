//
//  ManagedProtocol.swift
//  ManagedProtocol
//
//  Created by Yong Jin on 2021/8/14.
//

import Foundation
import CoreData

protocol Managed: NSFetchRequestResult {
    static var entityName: String {get}
    static var defaultSortDescriptors: [NSSortDescriptor] {get}
    
    static func makeDefaultPredicate(id: String) -> NSPredicate
    
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
       return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}


extension Managed where Self: NSManagedObject {
    static var entityName: String {return entity().name!}
}

