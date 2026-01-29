//
//  hotel_service.swift
//  login_ui
//
//  Created by Vinay H on 27/10/25.
//

import SwiftData

func addRestaurant(modelContext: ModelContext, hotel: RestaurantModel) -> (Bool, String){
    let allHotels = try? modelContext.fetch(FetchDescriptor<RestaurantModel>())
    let exists = allHotels?.contains(where: { $0.hotelName == hotel.hotelName }) ?? false
    
    if exists {
        return (false, "Restaurant with this name already exists")
    }
    
    modelContext.insert(hotel)
    try? modelContext.save()
    print("success adding Restaurant")
    return (true, "Restaurant added successfully")
}

func updateRestaurant(
    modelContext: ModelContext,
    hotel: RestaurantModel,
    with newValues: RestaurantModel
) -> (Bool, String) {
    // Check for name conflict
    let allHotels = try? modelContext.fetch(FetchDescriptor<RestaurantModel>())
    let nameExists = allHotels?.contains(where: {
        $0.hotelName == newValues.hotelName && $0.id != hotel.id
    }) ?? false
    
    if nameExists {
        return (false, "❌ Another restaurant with this name already exists.")
    }
    
    // Apply changes
    hotel.hotelName = newValues.hotelName
    hotel.shortDescription = newValues.shortDescription
    hotel.rating = newValues.rating
    hotel.avgDeliveryTime = newValues.avgDeliveryTime
    hotel.pricePerHead = newValues.pricePerHead
    hotel.mainOffer = newValues.mainOffer
    hotel.imgUrl = newValues.imgUrl
    
    try? modelContext.save()
    return (true, "✅ Restaurant updated successfully.")
}

func deleteRestaurant(modelContext: ModelContext, hotel: RestaurantModel) ->(Bool, String) {
    modelContext.delete(hotel)
    do {
        try modelContext.save()
        print("Restaurant deleted successfully.")
        return (true,"\(hotel.hotelName) deleted successfully.")
    }catch  {
        print("Error deleting restaurant: \(error)")
        return (false,"Error deleting restaurant.")
    }
}


func fetchRestaurants(modelContext: ModelContext) -> [RestaurantModel]{
    let descriptor = FetchDescriptor<RestaurantModel>()
    return (try? modelContext.fetch(descriptor)) ?? []
    
}
