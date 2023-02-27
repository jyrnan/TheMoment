//
//  MediaScreenModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/27.
//

import Foundation
import SwiftUI
import PhotosUI

class MediaScreenModel: ObservableObject {
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Data)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    //这个ViewModel的核心就是修改imageState的状态
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
//                let progress = loadTransferable(from: imageSelection)
//                imageState = .loading(progress)
                loadTransferable(from: imageSelection)
            } else {
                imageState = .empty
            }
        }
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let data?):
//                        self.imageState = .success(data)
                    self.createThumbnail(data: data, itemIdentifier: imageSelection.itemIdentifier)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    private func createThumbnail(data: Data, itemIdentifier: String?) {
        let thumbnail = CD_Thumbnail(context: viewContext)
        thumbnail.data = data
        thumbnail.title = itemIdentifier
        
        _ = viewContext.saveOrRollback()
    }
}
