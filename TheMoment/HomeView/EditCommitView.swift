//
//  NewCommitView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/17.
//

import PhotosUI
import SwiftUI

struct EditCommitView: View {
  @StateObject var vm: EditCommitViewModel
  
  @State var textEditorHeight: CGFloat = 20
    
  @Environment(\.dismiss) var dissmiss
  var uuid: UUID?
  var commit: CD_Commit?
    
  var isEditMode: Bool { commit != nil }
    
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.date, ascending: true)],
    animation: .default)
  private var cd_Branches: FetchedResults<CD_Branch>
    
  init(uuid: UUID? = nil, commit: CD_Commit? = nil) {
    _vm = StateObject(wrappedValue: EditCommitViewModel(commit: commit))
    self.uuid = uuid
    self.commit = commit
  }
    
  var body: some View {
    VStack {
      List {
//                Section(content: {
        Picker("Branch", selection: $vm.selectedBranch) {
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
                      .background(GeometryReader {
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: $0.frame(in: .local).size.height)
                      })
                    TextEditor(text: $vm.content)
                      .frame(height: max(40, textEditorHeight))
                      .padding(.horizontal)
                  }.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
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
                    TabView {
                      ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: UIImage(data: image.data!) ?? UIImage(systemName: "photo")!)
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                      }
                    }
                    .frame(height: 240)
                    .tabViewStyle(.page)
                  }
                            
                },
                header: { Text("Photo") },
                footer: {})
          .listRowInsets(.init(.init()))
                
        HStack {
          ForEach(vm.images, id: \.self) { image in
            ZStack {
              Image(uiImage: UIImage(data: image.data!) ?? UIImage(systemName: "photo")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .layoutPriority(-1)
              Color.clear
                .frame(width: 32, height: 32)
            }
            .cornerRadius(8)
            .clipped()
            .aspectRatio(contentMode: .fill)
          }
                    
          PhotosPicker(selection: $vm.imageSelections, maxSelectionCount: 9) {
            Image(systemName: "plus.circle.fill").font(.title).opacity(0.5)
          }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowBackground(Color.clear)
        .listRowInsets(.init())

        Section(content: {
                  Rectangle().fill(.gray)
                    .frame(height: 200)
                },
                header: { Text(vm.location) },
                footer: {})
          .listRowInsets(.init())
                
        if isEditMode {
          Button(role: .destructive, action: {
            viewContext.delete(commit!)
            dissmiss()
          }, label: { Text("Delete Commit").frame(maxWidth: .infinity, alignment: .center) })
        }
      }
      .scrollDismissesKeyboard(.immediately)

      Button {
        if isEditMode {
          guard vm.updateAndSave(commit: commit!) else { return }
          dissmiss()
        } else {
          let newCommit = vm.newCommit(uuid: uuid!)
          guard vm.updateAndSave(commit: newCommit) else { return }
          dissmiss()
        }
      } label: {
        Text(isEditMode ? "Save Commit" : "Add Commit")
      }
      .padding()
      .tint(.accentColor)
      .disabled(vm.title == "" && vm.content == "" && vm.images.isEmpty)
    }
  }
}

struct NewCommitView_Previews: PreviewProvider {
  static var previews: some View {
    EditCommitView(uuid: UUID(), commit: CD_Commit(context: PersistenceController.shared.container.viewContext))
      .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
  }
}

struct ViewHeightKey: PreferenceKey {
  static var defaultValue: CGFloat { 0 }
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value = value + nextValue()
  }
}
