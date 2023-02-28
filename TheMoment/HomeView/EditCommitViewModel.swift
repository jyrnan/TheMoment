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
    let viewContext = PersistenceController.shared.container.viewContext
    
    var commit: CD_Commit?
    
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var location: String = "22.54°N, 36.38°E"
    @Published var weather: String = ["Sunny", "Cloudy", "Rain", "Storm"].randomElement() ?? "Sunny"
    @Published var images: [CD_Thumbnail] = []
    
    @Published var selectedBranch: CD_Branch?
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            if !imageSelections.isEmpty {
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
    
    // MARK: - Functions
    
    private func configViewModel(with commit: CD_Commit) {
        self.title = commit.title ?? ""
        self.content = commit.content ?? ""
        self.location = commit.location ?? "22.54°N, 36.38°E"
        self.weather = commit.weather ?? "Sunny"
        self.images = commit.thumbnailsArray
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

extension EditCommitViewModel {
    fileprivate func convertPhotoPickerItem() async {
        var thumbnails: [CD_Thumbnail] = []
        await withTaskGroup(of: CD_Thumbnail?.self) { group in
            imageSelections.forEach { item in
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
            self.images.append(contentsOf: thumbnails)
            self.imageSelections.removeAll()
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) async -> CD_Thumbnail? {
        guard let data = try? await imageSelection.loadTransferable(type: Data.self) else { return nil }
        return await createThumbnail(data: data, itemIdentifier: imageSelection.itemIdentifier)
    }
    
    @MainActor
    private func createThumbnail(data: Data, itemIdentifier: String?) -> CD_Thumbnail {
        let thumbnail = CD_Thumbnail(context: viewContext)
        thumbnail.data = data
        thumbnail.title = itemIdentifier
        thumbnail.date = .now
        thumbnail.editAt = .now
        return thumbnail
    }
}
