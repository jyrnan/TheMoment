//
//  MediaScreen.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/27.
//

import SwiftUI
import PhotosUI

struct MediaScreen: View {
    @StateObject var vm = PhotoPickerViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Thumbnail.date, ascending: false)],
        animation: .default)
    private var thumbnails: FetchedResults<CD_Thumbnail>
    
    let gridRow = [GridItem(.adaptive(minimum: 120),spacing: 2)]
    var body: some View {
        ScrollView() {
            LazyVGrid(columns: gridRow,spacing: 2) {
                ForEach(thumbnails) {thumbnail in
                    ZStack {
                        Image(uiImage: (UIImage(data: thumbnail.data!) ?? UIImage(systemName: "photo"))!)
                            .resizable()
                            .scaledToFill()
                            .layoutPriority(-1)
                        Color.clear
                    }
                    .clipped()
                    .aspectRatio(1, contentMode: .fill)
                    
                                        }
                
                PhotosPicker(selection: $vm.imageSelections, maxSelectionCount: 9){
                    ZStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5)
                            .frame(width: 40, height: 40, alignment: .center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .border(.red).layoutPriority(-1)
                        
                        Circle()
                            .fill(.clear)
                    }
                }
                
            }
        }
    }
}

struct MediaScreen_Previews: PreviewProvider {
    static var previews: some View {
        MediaScreen()
    }
}
