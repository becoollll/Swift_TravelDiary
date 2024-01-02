//
//  Item.swift
//  TravelDiary
//
//  Created by 鄭宇婕 on 2023/12/21.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var date: Date
    var tel: String
    var add: String
    var comment: String
    var isFavorite: Bool
    var rating: Double
    
    init(name: String = "",
         date: Date = .now,
         tel: String = "",
         add: String = "",
         comment: String = "",
         isFavorite: Bool = false,
         rating: Double = 0
         ) {
        self.name = name
        self.date = date
        self.tel = tel
        self.add = add
        self.comment = comment
        self.isFavorite = isFavorite
        self.rating = rating
    }
}
