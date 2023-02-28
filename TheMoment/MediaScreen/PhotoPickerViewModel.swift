//
//  MediaScreenModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/27.
//

import Foundation
import PhotosUI
import SwiftUI

class PhotoPickerViewModel: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            if !imageSelections.isEmpty {
                Task {
                    await withTaskGroup(of: Void.self) { group in
                        imageSelections.forEach { item in
                            group.addTask {
                                await self.loadTransferable(from: item)
                            }
                        }
                    }
                    await MainActor.run {self.imageSelections.removeAll()}
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) async {
        do {
            if let data = try await imageSelection.loadTransferable(type: Data.self) {
                await createThumbnail(data: data, itemIdentifier: imageSelection.itemIdentifier)
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func createThumbnail(data: Data, itemIdentifier: String?) {
        withAnimation {
            let thumbnail = CD_Thumbnail(context: viewContext)
            thumbnail.data = data
            thumbnail.title = itemIdentifier
            
            thumbnail.date = .now
            thumbnail.editAt = .now
            
//            _ = viewContext.saveOrRollback()
        }
    }
}
