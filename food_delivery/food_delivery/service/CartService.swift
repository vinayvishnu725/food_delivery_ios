//
//  CartService.swift
//  food_delivery
//
//  Created by Vinay H on 28/01/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
class CartService {
    // Stores [ItemID: Quantity]
    var items: [UUID: Int] = [:]
    
    // Tracks which restaurant owns the current items
    var currentRestaurantID: UUID?
    
    var totalQuantity: Int { items.values.reduce(0, +) }
    var showSuccessToast = false

    func add(_ item: MenuModel) {
        // 1. Check if the cart is empty or belongs to the same restaurant
        if currentRestaurantID == nil || currentRestaurantID == item.hotelId {
            if currentRestaurantID == nil {
                currentRestaurantID = item.hotelId
            }
            items[item.id, default: 0] += 1
            print("cart items: \(items)")
            // Trigger the success message
                    withAnimation {
                        showSuccessToast = true
                    }
                    
                    // Hide it after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.showSuccessToast = false
                        }
                    }
        } else {
            // 2. Different restaurant detected
            print("Warning: Item belongs to a different restaurant.")
            // You can call clearCart() here automatically,
            // or use a boolean to show an alert in the UI first.
        }
    }
    
    func remove(_ itemID: UUID) {
        if let count = items[itemID], count > 1 {
            items[itemID] = count - 1
        } else {
            items.removeValue(forKey: itemID)
            // 3. If cart becomes empty, reset the restaurant ID
            if items.isEmpty {
                currentRestaurantID = nil
            }
        }
    }
    
    // 4. Method to manually clear the cart
    func clearCart() {
        items.removeAll()
        currentRestaurantID = nil
        print("Cart cleared successfully.")
    }
}
