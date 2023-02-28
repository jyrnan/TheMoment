//
//  ManagedProtocol.swift
//  ManagedProtocol
//
//  Created by Yong Jin on 2021/8/14.
//

import Foundation
import CoreData

//protocol Managed: NSFetchRequestResult {
//    static var entityName: String {get}
//    static var defaultSortDescriptors: [NSSortDescriptor] {get}
//    
//    static func makeDefaultPredicate(id: String) -> NSPredicate
//    var uuid: UUID? {get}
//}
//
extension NSManagedObject {
    static var defaultSortDescriptors: [NSSortDescriptor] {
       return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<NSManagedObject> {
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}


extension NSManagedObject {
    static var entityName: String {return entity().name!}
}



