//
//  NewCommitView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/17.
//

import PhotosUI
import SwiftUI

struct EditCommitView: View {
  
  //MARK: - Properties
  @StateObject var vm: EditCommitViewModel
  @Environment(\.dismiss) var dissmiss
  
  @State var textEditorHeight: CGFloat = 20
  var isEditMode: Bool { true }
  
//  @Binding var currentThumbnail: CD_Thumbnail?
  
  //MARK: -
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.date, ascending: true)],
    animation: .default)
  private var cd_Branches: FetchedResults<CD_Branch>
  
  //MARK: - init
  
  init(viewModel: EditCommitViewModel) {
    _vm = StateObject(wrappedValue: viewModel)
//    _currentThumbnail = currentThumbnail
  }
    
  var body: some View {
    VStack {
      List {
//                Section(content: {
        Picker("Branch", selection: $vm.currentBranch) {
          ForEach(cd_Branches) { branch in
            Text(branch.name ?? "Moment")
              .tag(branch)
              .tag(Optional(branch))
          }
        }
        .padding(.horizontal)
        .listRowInsets(.init())
                
        Section(content: {
                  TextField("Title", text: $vm.title)
                    .padding(.horizontal)
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
                header: { Text("Title and content") },
                footer: {
                  Text("\(Image(systemName: "sun.max")) \(vm.weather) \(arc4random_uniform(25))°C")
                    .font(.caption2)
                    .foregroundColor(.gray)
                })
                .listRowInsets(.init())
            
        Section(content: {
                  if !vm.images.isEmpty {
                    ImagePageTabView(thumbnails: vm.images, selectedThumbTab: $vm.selectedThumbTab)
                  }
                            
                },
                header: { Text("Photo") },
                footer: {})
          .listRowInsets(.init(.init()))
                
        HStack {
          ThumbnailRowView(thumbnails: vm.images, selectedThumbTab: $vm.selectedThumbTab)
                    
          PhotosPicker(selection: $vm.photosPickerItems, photoLibrary: .shared()) {
            Image(systemName: "plus.circle.fill").font(.title).opacity(0.5)
          }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowBackground(Color.clear)
        .listRowInsets(.init())

        Section(content: {
          MapView(region: $vm.region)
                    .frame(height: 200)
                },
                header: { Text(vm.location) },
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
        .tint(.accentColor)
        .disabled(vm.title == "" && vm.content == "" && vm.images.isEmpty)
      }
    }
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
