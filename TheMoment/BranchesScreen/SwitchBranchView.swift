//
//  SwitchBranchView.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/20.
//

import SwiftUI

struct SwitchBranchView: View {
    
    @Binding var selectedBranch: UUID?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CD_Branch.name, ascending: false)],
        animation: .default)
    private var branches: FetchedResults<CD_Branch>
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(branches) {branch in
                Circle()
                    .fill(branch.uuid == selectedBranch ? Color.accentColor : Color.white)
                    .padding(0)
                    .frame(width: 6, height: 6)
                    .padding(3)
            }
        }
        .padding(.trailing)
    }
}

struct SwitchBranchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchBranchView(selectedBranch: .constant(UUID()))
    }
}
