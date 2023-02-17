//
//  Branch.swift
//  TheMoment
//
//  Created by jyrnan on 2023/2/14.
//

import SwiftUI

struct Branch: Identifiable {
    var id = UUID()
    var name: String = ["Main","Banner", "Image", "Meat"].randomElement() ?? "Main"
    var bannerBGImage: String = ["Banner", "Image", "Meat"].randomElement() ?? "Banner"
    var avatar: String = "Avatar"
    var accentColor: Color = colors.randomElement() ?? .accentColor
    
}

extension Branch {
    static var new:Branch { Branch()}
    
    static var examples: [Branch] = (0...3).map{_ in new}
}

extension Branch {
    static var colors: [Color] = [.pink,.red, .blue, .green, .orange]
}
