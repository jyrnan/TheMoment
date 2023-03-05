//
//  EditCommitViewModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/18.
//

import CoreData
import Foundation
import MapKit
import PhotosUI
import SwiftUI

class EditCommitViewModel: NSObject, ObservableObject {
  // MARK: - Properties
  
  let viewContext = PersistenceController.shared.container.viewContext
  // 持有需要编辑的Commit
  var commit: CD_Commit?
  var locationManager = CLLocationManager()
  
  @Published var title: String = ""
  @Published var content: String = ""
  @Published var location: String = "22.54°N, 36.38°E"
  @Published var weather: String = "Sunny"
  // 可能需要调整的地图位置属性
  @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3315, longitude: -121.89),
                                             span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
  
  @Published var selectedBranch: CD_Branch?
  // 用来标记这个View里面缩略图Tab的选择项
  @Published var selectedThumbTab: CD_Thumbnail?
  
  @Published var images: [CD_Thumbnail] = []
  @Published var photosPickerItems: [PhotosPickerItem] = [] {
    didSet {
      if !photosPickerItems.isEmpty {
        Task {
          await convertPhotoPickerItem()
        }
      }
    }
  }
  // 临时记录添加的图片，如果执行Cancel操作，从Context中delete这些CD_Thumbnail
  var addedImageCache:[CD_Thumbnail] = []
  
  init(commit: CD_Commit? = nil) {
    super.init()
    configViewModel(with: commit)
    locationManager.delegate = self
  }
    
  // MARK: - Private Methods
    
  private func configViewModel(with commit: CD_Commit?) {
    guard let commit = commit else { return }
    self.commit = commit
    title = commit.title ?? ""
    content = commit.content ?? ""
    location = commit.location ?? "22.54°N, 36.38°E"
    weather = commit.weather ?? "Sunny"
    images = commit.thumbnailsArray
    selectedBranch = commit.branch
  }
    
  func newCommit() -> CD_Commit {
    let commit: CD_Commit = viewContext.insertObject()
    commit.uuid = UUID()
    // 创建时间在首次创建进行修改
    updateDate(commit: commit, date: .now)
    return commit
  }
    
  func updateAndSave() -> Bool {
    let commit = self.commit ?? newCommit()
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
  
  func cancel() {
    addedImageCache.forEach{viewContext.delete($0)}
    images.removeAll()
    try? viewContext.save()
  }
}
