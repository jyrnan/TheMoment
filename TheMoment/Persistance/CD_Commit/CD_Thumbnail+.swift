//
//  CD_Thumbnail+.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/28.
//

import Foundation
import SwiftUI
import CoreData

extension CD_Thumbnail {
    static func sample1(context: NSManagedObjectContext) -> CD_Thumbnail {
        let thumbnail = CD_Thumbnail(context: context)
        thumbnail.title = "Image"
        
        return thumbnail
    }
}
