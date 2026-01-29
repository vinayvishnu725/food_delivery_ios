//
//  menu_db.swift
//  food_delivery
//
//  Created by Vinay H on 14/11/25.
//

import SwiftData
import Foundation

func addMenu(modelContext: ModelContext, menuData: MenuModel) -> (Bool, String){
    let allMenu = try? modelContext.fetch(FetchDescriptor<MenuModel>())
    let exists = allMenu?.contains(where: { $0.dishName == menuData.dishName }) ?? false
    
    if exists {
        return (false, "Menu with this name already exists")
    }
    
    modelContext.insert(menuData)
    try? modelContext.save()
    print("success adding Menu")
    return (true, "Menu added successfully")
}

func updateMenu(
    modelContext: ModelContext,
    menuData: MenuModel,
    with newValues: MenuModel
) -> (Bool, String) {
    // Check for name conflict
    let allMenu = try? modelContext.fetch(FetchDescriptor<MenuModel>())
    let nameExists = allMenu?.contains(where: {
        $0.dishName == newValues.dishName && $0.id != menuData.id
    }) ?? false
    
    if nameExists {
        return (false, "❌ Another menu with this name already exists.")
    }
    
    // Apply changes
    menuData.dishName = newValues.dishName
    menuData.menuName = newValues.menuName
    menuData.dishSubTitle = newValues.dishSubTitle
    menuData.items = newValues.items
    menuData.rating = newValues.rating
    menuData.imgUrl = newValues.imgUrl
    menuData.prize = newValues.prize
    
    try? modelContext.save()
    return (true, "✅ Menu updated successfully.")
}

func deleteMenu(modelContext: ModelContext, menuData: MenuModel) ->(Bool, String) {
    modelContext.delete(menuData)
    do {
        try modelContext.save()
        print("Menu deleted successfully.")
        return (true,"\(menuData.dishName) deleted successfully.")
    }catch  {
        print("Error deleting menu: \(error)")
        return (false,"Error deleting menu.")
    }
}


func fetchAllMenu(modelContext: ModelContext) -> [MenuModel]{
    let descriptor = FetchDescriptor<MenuModel>()
    return (try? modelContext.fetch(descriptor)) ?? []
}

func fetchMenuByHotelId(modelContext: ModelContext, hotelId: UUID) -> [MenuModel] {
    // 1. Create a predicate to filter by hotelId
    let predicate = #Predicate<MenuModel> { menu in
        menu.hotelId == hotelId
    }
    
    // 2. Create a FetchDescriptor with that predicate
    let descriptor = FetchDescriptor<MenuModel>(predicate: predicate)
    
    // 3. Perform the fetch
    do {
        return try modelContext.fetch(descriptor)
    } catch {
        print("Failed to fetch menus for hotel \(hotelId): \(error)")
        return []
    }
}
