//
//  PostDetailView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/3.
//

import SwiftUI

struct DetailView: View {
    var id: UUID
    @Binding var path: [UUID]
    
    var body: some View {
        VStack {
            Text("Detail\n \(id.debugDescription)")
            Button("Enter", action: {
                path.append(id)
                print(id.debugDescription)
            })
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: UUID(), path: .constant([]))
    }
}
