//
//  Commit.swift
//  FoodPicker
//
//  Created by Jane Chao on 22/10/09.
//

import Foundation
import CoreData

struct Commit: Equatable, Identifiable {
    let id = UUID()
    var location:String?
    var title: String?
    var content: String?
    var emoji: String?
    var images: [String] = []
    
    var date: Date = .now
    var weather: String? = ["Sunny", "Cloudy", "Rain", "Storm"].randomElement()
    
    
}


// MARK: statics
extension Commit {
    static var new: Commit { Commit(title: "", emoji: "") }
    
    static let examples = [
        Commit(title: "今天的漢堡很不错的", emoji: "😆"),
        Commit(title: "沙拉很不错",content: "沙拉是一种以混合经过切碎或打碎的蔬菜，果蔬，肉类，鱼类，乳制品，蛋类或其他食物组成的膳食。沙拉可以有很多不同的口味，例如甜，咸，酸，辣，清淡等等。沙拉也可以搭配油脂和酱汁，以赋予食物不同的口感。沙拉可以是前菜或主菜，也可以单独食用，只要搭配上合适的油脂和酱汁，就能让沙拉拥有独特的风味。" ),
        Commit(title: "今天的披薩很不错的还有刀削面也很不错的", content: "沙拉是一种以混合经过切碎或打碎的蔬菜，果蔬，肉类，鱼类，乳制品，蛋类或其他食物组成的膳食。沙拉可以有很多不同的口味，例如甜，咸，酸，辣，清淡等等。", images: ["Image"]),
        Commit(images: ["Image"]),
        Commit(images: ["Meat"]),
        Commit(title: "雞腿便當刀削麵", images: ["Meat"]),
        Commit(content: "沙拉是一种以混合经过切碎或打碎的蔬菜，果蔬，肉类，鱼类，乳制品，蛋类或其他食物组成的膳食。沙拉可以有很多不同的口味，例如甜，咸，酸，辣，清淡等等。沙拉也可以搭配油脂和酱汁，以赋予食物不同的口感。沙拉可以是前菜或主菜，也可以单独食用，只要搭配上合适的油脂和酱汁，就能让沙拉拥有独特的风味。" ),
        Commit(title: "火鍋", emoji: "🤣"),
        Commit(title: "火鍋牛肉麵關東煮", emoji: "🕟")
    ]
}

//extension Commit {
//    func cd_commit(context: NSManagedObjectContext) -> CD_Commit {
//        let commit: CD_Commit = context.insertObject()
//        commit.uuid = id
//        commit.title = title
//        commit.content = content
//        commit.date = date
//        commit.emoji = emoji
//        commit.location = location
//        commit.images = images
//        
//        context.saveOrRollback()
//        
//        return commit
//    }
//}
