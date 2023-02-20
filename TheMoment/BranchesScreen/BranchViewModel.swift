//
//  BranchViewModel.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/13.
//

import SwiftUI

class BranchViewModel: ObservableObject {
   
    @Published var selectedBranch: UUID?
    
    // NavigationStack path
    @Published var path: [UUID] = []
    
}
