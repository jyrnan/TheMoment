//
//  CD_Thumbnail+.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/28.
//

import CoreData
import Foundation
import SwiftUI

extension CD_Thumbnail {
  
  static var sample: CD_Thumbnail {
    let thumbnail = CD_Thumbnail(context: PersistenceController.viewContext)
    thumbnail.date = .now
    thumbnail.data = UIImage(systemName: "photo")?.jpegData(compressionQuality: 1)!
    return thumbnail
  }
}
