//
//  NewCommitView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/17.
//

import SwiftUI

struct NewCommitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var id: UUID
    
    var body: some View {
        Form {
            Text("New Commit id: \(id)")
            
            Button{
                addItem()
            } label: {
                Text("Add Commit")
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
        }
    }
    
    private func addItem() {
        viewContext.addItem()
    }
}

struct NewCommitView_Previews: PreviewProvider {
    static var previews: some View {
        NewCommitView(id: UUID())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
