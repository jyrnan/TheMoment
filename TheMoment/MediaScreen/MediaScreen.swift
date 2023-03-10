//
//  MediaScreen.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/27.
//

import PhotosUI
import SwiftUI

struct MediaScreen: View {
  @StateObject var vm = PhotoPickerViewModel()
  @Binding var fullSheet: HomeView.Sheet?

  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \CD_Thumbnail.date, ascending: false)],
    animation: .default)
  private var thumbnails: FetchedResults<CD_Thumbnail>

  let gridRow = [GridItem(.adaptive(minimum: 120), spacing: 2)]
  var body: some View {
    ScrollView {
      LazyVGrid(columns: gridRow, spacing: 2) {
        ForEach(thumbnails) { thumbnail in
          ZStack {
            Image(uiImage: (UIImage(data: thumbnail.data!)!))
              .resizable()
              .scaledToFill()
              .layoutPriority(-1)
              .onTapGesture {
                if let commit = thumbnail.commit {
                  let viewModel = EditCommitViewModel(commit: commit)
                  viewModel.selectedThumbTab = thumbnail
                  fullSheet = .editCommit(viewModel)
                } else {
                  fullSheet = makeCommitByImage(thumbnail: thumbnail)
                }
              }
            Color.clear
          }

          .clipped()
          .aspectRatio(1, contentMode: .fill)
          .overlay(alignment: .bottomTrailing) {
            Image(systemName: "link.badge.plus")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 24, height: 24)
              .foregroundColor(.white)
              .padding(6)
              .opacity(thumbnail.commit == nil ? 1 : 0)
          }
        }
      }
    }
  }
}

struct MediaScreen_Previews: PreviewProvider {
  static var previews: some View {
    MediaScreen(fullSheet: .constant(.newCommit(EditCommitViewModel())))
  }
}

extension MediaScreen {
  
  private func makeCommitByImage(thumbnail: CD_Thumbnail) -> HomeView.Sheet {
    let commit = CD_Commit(context: viewContext)
    commit.uuid = UUID()
    commit.images = NSSet(object: thumbnail)
    commit.date = thumbnail.date
    commit.editAt = .now
    
    let viewModel = EditCommitViewModel(commit: commit)

    return .editCommit(viewModel)
  }
}
