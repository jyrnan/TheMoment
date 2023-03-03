//
//  EditCommitViewModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/18.
//

import CoreData
import Foundation
import PhotosUI
import SwiftUI

class EditCommitViewModel: ObservableObject {
  // MARK: - Properties
  
  let viewContext = PersistenceController.shared.container.viewContext
    
  var commit: CD_Commit?
    
  @Published var title: String = ""
  @Published var content: String = ""
  @Published var location: String = "22.54°N, 36.38°E"
  @Published var weather: String = ["Sunny", "Cloudy", "Rain", "Storm"].randomElement() ?? "Sunny"
  @Published var images: [CD_Thumbnail] = []
    
  @Published var selectedBranch: CD_Branch?
  
  @Published var photosPickerItems: [PhotosPickerItem] = [] {
    didSet {
      if !photosPickerItems.isEmpty {
        Task {
          await convertPhotoPickerItem()
        }
      }
    }
  }
    
  init(commit: CD_Commit? = nil) {
    if let commit = commit {
      configViewModel(with: commit)
    }
  }
    
  // MARK: - Private Methods
    
  private func configViewModel(with commit: CD_Commit) {
    title = commit.title ?? ""
    content = commit.content ?? ""
    location = commit.location ?? "22.54°N, 36.38°E"
    weather = commit.weather ?? "Sunny"
    images = commit.thumbnailsArray
  }
    
  func newCommit(uuid: UUID) -> CD_Commit {
    let commit: CD_Commit = viewContext.insertObject()
    commit.uuid = uuid
    // 创建时间在首次创建进行修改
    updateDate(commit: commit, date: .now)
    return commit
  }
    
  func updateAndSave(commit: CD_Commit) -> Bool {
    commit.title = title.count > 0 ? title : nil
    commit.content = content.count > 0 ? content : nil
    commit.branch = selectedBranch
    commit.editAt = .now
    commit.images = NSSet(array: images)
        
    return viewContext.saveOrRollback()
  }
    
  func delete(commit: CD_Commit) -> Bool {
    viewContext.delete(commit)
    return viewContext.saveOrRollback()
  }
    
  func updateDate(commit: CD_Commit, date: Date) {
    commit.date = date
  }
}

// MARK: - Extension for

extension EditCommitViewModel {
  fileprivate func convertPhotoPickerItem() async {
    var thumbnails: [CD_Thumbnail] = []
    await withTaskGroup(of: CD_Thumbnail?.self) { group in
      photosPickerItems.forEach { item in
        group.addTask {
          await self.loadTransferable(from: item)
        }
      }
            
      for await thumbnail in group {
        if let thumbnail = thumbnail {
          thumbnails.append(thumbnail)
        }
      }
    }
        
    await MainActor.run { [thumbnails] in
      let thumbnails = thumbnails.compactMap { viewContext.object(with: $0.objectID) as? CD_Thumbnail }
      self.images.append(contentsOf: thumbnails)
      self.photosPickerItems.removeAll()
    }
  }
    
  private func loadTransferable(from imageSelection: PhotosPickerItem) async -> CD_Thumbnail? {
    guard let data = try? await imageSelection.loadTransferable(type: Data.self), let itemIdentifier = imageSelection.itemIdentifier else { return nil }
    
    let thumbData = await ImageCompressor.getCompressBySize(data: data)
    
    return await createThumbnailBg(data: data, thumbData: thumbData, itemIdentifier: itemIdentifier)
  }
    
  @MainActor
  private func createThumbnail(data: Data, thumbData: Data, itemIdentifier: String) -> CD_Thumbnail {
    let origin = CD_Image(context: viewContext)
    origin.data = data
    origin.title = itemIdentifier
    origin.date = .now
    origin.editAt = .now
    origin.uuid = UUID()
    
    let thumbnail = CD_Thumbnail(context: viewContext)
    thumbnail.data = thumbData
    thumbnail.title = itemIdentifier
    thumbnail.date = .now
    thumbnail.editAt = .now
    thumbnail.uuid = UUID()
    thumbnail.origin = origin
    
    return thumbnail
  }
  
  private func createThumbnailBg(data: Data, thumbData: Data, itemIdentifier: String) async -> CD_Thumbnail? {
    let container = PersistenceController.shared.container
    
    return try? await container.performBackgroundTask { context in
      
      let asset = PHAsset.fetchAssets(withLocalIdentifiers: [itemIdentifier], options: nil)
     
      let origin = CD_Image(context: context)
      origin.data = data
      origin.title = itemIdentifier
      origin.date = asset.firstObject?.creationDate
      origin.editAt = .now
      origin.uuid = UUID()
      
      let thumbnail = CD_Thumbnail(context: context)
      thumbnail.data = thumbData
      thumbnail.title = itemIdentifier
      thumbnail.date = asset.firstObject?.creationDate
      thumbnail.editAt = .now
      thumbnail.uuid = UUID()
      thumbnail.origin = origin
      
//      do {
      try context.save()
      return thumbnail
//      } catch {
//        fatalError()
//      }
    }
  }
}
