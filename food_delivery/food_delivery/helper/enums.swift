//
//  enums.swift
//  login_ui
//
//  Created by Vinay H on 05/11/25.
//

import SwiftUI


enum AppRoute: Hashable {
    case homeScreen
    case settings
    case addOrUpdateRestaurant(restaurant: RestaurantModel?)
    case listRestaurant
    case restaurantDetails(restaurant: RestaurantModel)
    case addOrUpdateMenu(menuData: MenuModel?, restaurant: RestaurantModel)
    case menuList(restaurant: RestaurantModel)
    case cartScreen
    
}

enum Tab: Hashable {
    case home, settings
}
