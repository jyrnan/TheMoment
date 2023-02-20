//
//  CD_Branch+.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//

import Foundation
import SwiftUI

//extension CD_Branch: Managed {}

extension CD_Branch {
    static var initial: CD_Branch {
        let branch = CD_Branch()
//        branch.name = "Moment"
        return branch
    }
}

extension CD_Branch {
    enum BranchColor: String, CaseIterable, Hashable {
        case red
        case green
        case blue
        case pink
        case orange
        case system
        
        var value: Color {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
            case .pink:
                return .pink
            case .orange:
                return .orange
            case .system:
                return .blue
            }
        }
    }
    
    var color: Color {
        return BranchColor(rawValue: self.accentColor ?? "system")!.value
    }
}
