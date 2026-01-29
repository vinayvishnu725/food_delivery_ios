//
//  restaurant_model.swift
//  login_ui
//
//  Created by Vinay H on 27/10/25.
//

import SwiftData
import Foundation

@Model
class RestaurantModel {
    var id: UUID
    var hotelName: String
    var shortDescription: String
    var rating: Double
    var avgDeliveryTime: String
    var pricePerHead: String
    var mainOffer: String
    var imgUrl: String
    
    init(id: UUID =  UUID(), hotelName: String, shortDescription: String, rating: Double, avgDeliveryTime: String, pricePerHead: String, mainOffer: String, imgUrl: String) {
        self.id = id
        self.hotelName = hotelName
        self.shortDescription = shortDescription
        self.rating = rating
        self.avgDeliveryTime = avgDeliveryTime
        self.pricePerHead = pricePerHead
        self.mainOffer = mainOffer
        self.imgUrl = imgUrl
    }
}

