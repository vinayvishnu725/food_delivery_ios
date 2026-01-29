//
//  food_deliveryApp.swift
//  food_delivery
//
//  Created by Vinay H on 07/11/25.
//

import SwiftUI
import SwiftData

@main
struct food_deliveryApp: App {
    @State private var cart = CartService()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(cart)
        .modelContainer(for: [
            RestaurantModel.self,
            MenuModel.self
        ])
    }
}
