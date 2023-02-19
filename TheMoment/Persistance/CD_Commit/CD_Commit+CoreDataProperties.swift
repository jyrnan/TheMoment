//
//  CD_Commit+CoreDataProperties.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/17.
//
//

import CoreData
import Foundation

public extension CD_Commit {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CD_Commit> {
        return NSFetchRequest<CD_Commit>(entityName: "CD_Commit")
    }

    @NSManaged var uuid: UUID?
    @NSManaged var location: String?
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var emoji: String?
    @NSManaged var images: [String]?
    @NSManaged var date: Date?
    @NSManaged var weather: String?
}

extension CD_Commit: Identifiable {}


