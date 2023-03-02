//
//  CD_Commit+Managed.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//

import CoreData
import Foundation
import SwiftUI

// extension CD_Commit: Managed {
//
// }

extension CD_Commit {
  static func new(context: NSManagedObjectContext) -> CD_Commit {
    let commit = CD_Commit(context: context)
    commit.title = "Test"
    commit.uuid = UUID()
    commit.content = "TheMoment[3626:983176] [general] 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release"
    commit.date = Date.now
    commit.images = [CD_Thumbnail.sample1(context: context)]
        
    return commit
  }

  static func noTitle(context: NSManagedObjectContext) -> CD_Commit {
    let commit = CD_Commit(context: context)
    commit.uuid = UUID()
    commit.content = "TheMoment[3626:983176] [general] 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release"
    commit.date = Date.now
    commit.images = [CD_Thumbnail.sample1(context: context)]
        
    return commit
  }
    
  var thumbnails: [UIImage] {
    guard images?.count != 0 else { return [] }
    if let datas = images?.compactMap({ ($0 as? CD_Thumbnail)?.data }) {
      return datas.compactMap { UIImage(data: $0) }
    }
    return []
  }
    
  var firstThumbnail: UIImage {
    guard !thumbnails.isEmpty else { return UIImage(systemName: "photo")! }
    return thumbnails.first!
  }
    
  var thumbnailsDic: [NSManagedObjectID: UIImage] {
    var thumbnailsDic = [NSManagedObjectID: UIImage]()
    guard images?.count != 0 else { return thumbnailsDic }
    images?.forEach {
      if let thumbnail = $0 as? CD_Thumbnail,
         let data = thumbnail.data,
         let image = UIImage(data: data)
      {
        thumbnailsDic[thumbnail.objectID] = image
      }
    }
    return thumbnailsDic
  }
    
  var thumbnailsArray: [CD_Thumbnail] {
//        var thumbnailsArray = [CD_Thumbnail]()
    guard images != nil else { return [] }
    let thumbnailsArray = images!.compactMap { $0 as? CD_Thumbnail }.sorted { $0.date! < $1.date! }
    return thumbnailsArray
  }
  
  var originArray: [CD_Image] {
    return thumbnailsArray.compactMap{$0.origin}
  }
}
