//
//  Commit.swift
//  FoodPicker
//
//  Created by Jane Chao on 22/10/09.
//

import Foundation

struct Commit: Equatable, Identifiable {
    let id = UUID()
    var name: String
    var image: String
    @Suffix("大卡") var calorie: Double = .zero
    @Suffix("g") var carb: Double      = .zero
    @Suffix("g") var fat: Double       = .zero
    @Suffix("g") var protein: Double   = .zero
}


// MARK: statics
extension Commit {
    static var new: Commit { Commit(name: "", image: "") }
    
    static let examples = [
        Commit(name: "漢堡", image: "🍔", calorie: 294, carb: 14, fat: 24, protein: 17),
        Commit(name: "沙拉", image: "🥗", calorie: 89, carb: 20, fat: 0, protein: 1.8),
        Commit(name: "披薩", image: "🍕", calorie: 266, carb: 33, fat: 10, protein: 11),
        Commit(name: "義大利麵", image: "🍝", calorie: 339, carb: 74, fat: 1.1, protein: 12),
        Commit(name: "雞腿便當", image: "🍗🍱", calorie: 191, carb: 19, fat: 8.1, protein: 11.7),
        Commit(name: "刀削麵", image: "🍜", calorie: 256, carb: 56, fat: 1, protein: 8),
        Commit(name: "火鍋", image: "🍲", calorie: 233, carb: 26.5, fat: 17, protein: 22),
        Commit(name: "牛肉麵", image: "🐄🍜", calorie: 219, carb: 33, fat: 5, protein: 9),
        Commit(name: "關東煮", image: "🥘", calorie: 80, carb: 4, fat: 4, protein: 6),
    ]
}

@propertyWrapper struct Suffix: Equatable {
    var wrappedValue: Double
    private let suffix: String
    
    init(wrappedValue: Double, _ suffix: String) {
        self.wrappedValue = wrappedValue
        self.suffix = suffix
    }
    
    var projectedValue: String {
        wrappedValue.formatted() + " \(suffix)"
    }
}