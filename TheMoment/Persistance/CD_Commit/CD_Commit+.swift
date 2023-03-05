//
//  CD_Commit+Managed.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//

import CoreData
import Foundation
import SwiftUI

extension CD_Commit {
  static var sample:CD_Commit {
    let commit = CD_Commit(context: PersistenceController.viewContext)
    commit.title = "Sample"
    commit.uuid = UUID()
    commit.content = "TheMoment[3626:983176] [general] 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release"
    commit.date = Date.now
    commit.images = [CD_Thumbnail.sample]
    
    return commit
  }
}

extension CD_Commit {
    
  var thumbImages: [UIImage] {
    guard images?.count != 0 else { return [] }
    if let datas = images?.compactMap({ ($0 as? CD_Thumbnail)?.data }) {
      return datas.compactMap { UIImage(data: $0) }
    }
    return []
  }
    
  var firstThumbImage: UIImage {
    guard !thumbImages.isEmpty else { return UIImage(systemName: "photo")! }
    return thumbImages.first!
  }
    
  var thumbnailsArray: [CD_Thumbnail] {
    guard images != nil else { return [] }
    let context = PersistenceController.shared.container.viewContext
    let thumbnailsArray = images!
      .compactMap { context.object(with: ($0 as? CD_Thumbnail)!.objectID) as? CD_Thumbnail}
      .sorted {$0.date! < $1.date!}
    return thumbnailsArray
  }
  
  var originArray: [CD_Image] {
    return thumbnailsArray.compactMap { $0.origin }
  }
}
