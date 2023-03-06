//
//  NewCommitView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/17.
//

import PhotosUI
import SwiftUI

struct EditCommitView: View {
  // MARK: - Properties

  @StateObject var vm: EditCommitViewModel
  @Environment(\.dismiss) var dissmiss
  
  @State var textEditorHeight: CGFloat = 20
  var isEditMode: Bool { true }
    
  // MARK: -

  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.date, ascending: true)],
    animation: .default)
  private var cd_Branches: FetchedResults<CD_Branch>
  
  // MARK: - init
  
  init(viewModel: EditCommitViewModel) {
    _vm = StateObject(wrappedValue: viewModel)
  }
    
  var body: some View {
    VStack(spacing: 0) {
      List {
        Section(content: {
                  TextField("Title", text: $vm.title)
                    .padding(.horizontal)
                    .bold()
                    .font(.title3)
                  
                  ZStack(alignment: .leading) {
                    Text(vm.content)
                      .font(.system(.body))
                      .foregroundColor(.clear)
                      .padding(14)
                      .frame(maxHeight: 300)
                      .background(GeometryReader {
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: $0.frame(in: .local).size.height)
                      })
                    
                    TextEditor(text: $vm.content)
                      .frame(height: max(40, textEditorHeight))
                      .padding(.horizontal)
                  }
                  .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
                },
                header: {
                  HStack {
                    Text("Words")
                    Spacer()
                    Text("Branch - ")
                    Picker("", selection: $vm.currentBranch) {
                      ForEach(cd_Branches) { branch in
                        Text(branch.name ?? "Moment")
                          .tag(branch)
                          .tag(Optional(branch))
                      }
                    }
                  }
          
                },
                footer: {
//                  Text("\(Image(systemName: "sun.max")) \(vm.weather) \(arc4random_uniform(25))°C")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
                })
                .padding(.top, 20)
                .listRowInsets(.init())
        
        Section(content: {
                  if !vm.images.isEmpty {
                    ImagePageTabView(thumbnails: vm.images, selectedThumbTab: $vm.selectedThumbTab)
                  }
                },
                header: { Text("Photo") },
                footer: { Text(vm.selectedThumbTab?.date?.formatted() ?? "").frame(maxWidth: .infinity, alignment: .trailing) })
          .listRowInsets(.init(.init()))
                
        HStack {
          ThumbnailRowView(thumbnails: vm.images, selectedThumbTab: $vm.selectedThumbTab)
                    
          PhotosPicker(selection: $vm.photosPickerItems, photoLibrary: .shared()) {
            Image(systemName: "photo.on.rectangle.angled").font(.title)
          }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowBackground(Color.clear)
        .listRowInsets(.init())
        .task {
          guard vm.selectedThumbTab == nil, let first = vm.images.first else { return }
          vm.selectedThumbTab = first
        }

        Section(content: {
                  MapView(region: $vm.region)
                    .frame(height: 200)
                },
                header: { HStack {Text(vm.location)
          Text("\(Image(systemName: "sun.max")) \(vm.weather) \(arc4random_uniform(25))°C")
        }},
                footer: {})
          .listRowInsets(.init())
                
        if isEditMode {
          Button(role: .destructive, action: {
            dissmiss()

          }, label: { Text("Delete Commit").frame(maxWidth: .infinity, alignment: .center) })
        }
      }
      .scrollDismissesKeyboard(.immediately)

      HStack {
        Button(role: .cancel,
               action: {
                 dissmiss()
                 vm.cancel()
               },
               label: { Text("Cancel") })
          .padding()
        
        Spacer()
        
        Button {
          if vm.updateAndSave() {
            dissmiss()
          }
        } label: {
          Text(vm.commit == nil ? "Add" : "Save")
        }
        .padding()
        .disabled(vm.title == "" && vm.content == "" && vm.images.isEmpty)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct NewCommitView_Previews: PreviewProvider {
  static var previews: some View {
    EditCommitView(viewModel: EditCommitViewModel())
      .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
  }
}

struct ViewHeightKey: PreferenceKey {
  static var defaultValue: CGFloat { 0 }
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value = value + nextValue()
  }
}
