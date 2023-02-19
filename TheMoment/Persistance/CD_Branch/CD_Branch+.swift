//
//  CD_Branch+.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/19.
//

import Foundation

extension CD_Branch: Managed {}

extension CD_Branch {
    static var initial: CD_Branch {
        let branch = CD_Branch()
//        branch.name = "Moment"
        return branch
    }
}
