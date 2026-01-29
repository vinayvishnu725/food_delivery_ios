//
//  menu_model.swift
//  food_delivery
//
//  Created by Vinay H on 12/11/25.
//

import SwiftData
import Foundation

@Model
class MenuModel {
    var hotelId: UUID
    var id: UUID
    var menuName: String
    var dishName: String
    var dishSubTitle : String
    var items: String
    var rating: Double
    var imgUrl: String
    var prize: Double
    
    init(hotelId: UUID, id: UUID = UUID(), menuName: String, dishName: String, dishSubTitle: String, items:String, rating: Double, imgUrl: String, prize: Double) {
        self.id = id
        self.hotelId = hotelId
        self.menuName = menuName
        self.dishName = dishName
        self.dishSubTitle = dishSubTitle
        self.items = items
        self.rating = rating
        self.imgUrl = imgUrl
        self.prize = prize
    }
}
