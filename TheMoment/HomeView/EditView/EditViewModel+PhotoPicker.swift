//
//  EditViewModel+PhotoPicker.swift
//  TheMoment
//
//  Created by jyrnan on 2023/3/5.
//

import PhotosUI
import SwiftUI

// MARK: - Extension for PhotoPikcer

extension EditCommitViewModel {
  func convertPhotoPickerItem() async {
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
      self.addedImageCache.append(contentsOf: thumbnails)
      self.photosPickerItems.removeAll()
    }
  }
    
  private func loadTransferable(from imageSelection: PhotosPickerItem) async -> CD_Thumbnail? {
    guard let data = try? await imageSelection.loadTransferable(type: Data.self), let itemIdentifier = imageSelection.itemIdentifier else { return nil }
    
    let thumbData = await ImageCompressor.getCompressBySize(data: data)
    
    return await createThumbnailBg(data: data, thumbData: thumbData, itemIdentifier: itemIdentifier)
  }
    
  private func createThumbnailBg(data: Data, thumbData: Data, itemIdentifier: String) async -> CD_Thumbnail? {
    let container = PersistenceController.shared.container
    
    return try? await container.performBackgroundTask { context in
      
      let asset = PHAsset.fetchAssets(withLocalIdentifiers: [itemIdentifier], options: nil)
     
      let origin = CD_Image(context: context)
      origin.data = data
      origin.title = itemIdentifier
      origin.date = asset.firstObject?.creationDate ?? .now
      origin.editAt = .now
      origin.uuid = UUID()
      
      let thumbnail = CD_Thumbnail(context: context)
      thumbnail.data = thumbData
      thumbnail.title = itemIdentifier
      thumbnail.date = asset.firstObject?.creationDate ?? .now
      thumbnail.editAt = .now
      thumbnail.uuid = UUID()
      thumbnail.origin = origin
      
      try context.save()
      return thumbnail

    }
  }
}
