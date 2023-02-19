//
//  CD_Branch+CoreDataProperties.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//
//

import Foundation
import CoreData


extension CD_Branch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_Branch> {
        return NSFetchRequest<CD_Branch>(entityName: "CD_Branch")
    }

    @NSManaged public var accentColor: String?
    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var avatarImage: CD_Image?
    @NSManaged public var bannerImage: CD_Image?
    @NSManaged public var commit: CD_Commit?

}

extension CD_Branch : Identifiable {

}
