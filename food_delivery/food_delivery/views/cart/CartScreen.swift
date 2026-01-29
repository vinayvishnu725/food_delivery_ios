//
//  cartScreen.swift
//  food_delivery
//
//  Created by Vinay H on 28/01/26.
//

import SwiftUI
import SwiftData

struct CartScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(CartService.self) private var cartService // Assuming you injected it into the environment
    @EnvironmentObject var router: Router
    // Fetch all menu items to find the ones currently in the cart
    @Query private var allMenuItems: [MenuModel]
    
    // User Detail States
        @State private var userName: String = ""
        @State private var phoneNumber: String = ""
        @State private var address: String = ""
    
    // Alert State
        @State private var showingOrderAlert = false
    
    // Filter items to only those in the cart
    var itemsInCart: [MenuModel] {
        allMenuItems.filter { cartService.items.keys.contains($0.id) }
    }
    
    // Calculate total price dynamically
    var totalPrice: Double {
        itemsInCart.reduce(0) { sum, item in
            sum + (item.prize * Double(cartService.items[item.id] ?? 0))
        }
    }
    
    // 1. Validation Logic
        var isFormValid: Bool {
            !userName.trimmingCharacters(in: .whitespaces).isEmpty &&
            phoneNumber.count >= 10 && // Basic check for phone length
            !address.trimmingCharacters(in: .whitespaces).isEmpty &&
            !cartService.items.isEmpty // Ensure cart isn't empty
        }


 
        
        var body: some View {
            VStack {
                cartViewBackButton()

                
                if itemsInCart.isEmpty {
                    ContentUnavailableView("Your cart is empty", systemImage: "cart")
                } else {
                    ScrollView {
                                    VStack(spacing: 30) {
                                        // 1. Cart Items
                                        VStack(spacing: 20) {
                                            ForEach(itemsInCart) { menu in
                                                CartRowView(menu: menu)
                                            }
                                        }
                                        
                                        // 2. User Information Section
                                        VStack(alignment: .leading, spacing: 15) {
                                            Text("Delivery Details")
                                                .font(.headline)
                                                .padding(.horizontal)
                                            
                                            VStack(spacing: 12) {
                                                customTextField(placeholder: "Full Name", text: $userName, icon: "person")
                                                customTextField(placeholder: "Phone Number", text: $phoneNumber, icon: "phone")
                                                    .keyboardType(.phonePad)
                                                customTextField(placeholder: "Delivery Address", text: $address, icon: "mappin.and.ellipse")
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    .padding(.top)
                                }
                }
                Spacer()
                // Footer
                footerView
            } .navigationBarBackButtonHidden(true)
            // 1. Define the Alert here
            .alert("Order Confirmed", isPresented: $showingOrderAlert) {
                Button("OK") {
                    // 3. Navigate back or to a success screen after alert is dismissed
                    cartService.clearCart()
                    router.pop()
                }
            } message: {
                Text("Thank you, \(userName)! Your order is being prepared and will arrive in 30 mins.")
            }
        }
    
    private func customTextField(placeholder: String, text: Binding<String>, icon: String) -> some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                TextField(placeholder, text: text)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    

    
    struct cartViewBackButton: View {
        @State private var selectedMainTab: Tab = .settings
        @EnvironmentObject var router: Router
        
        var body: some View {
            HStack {
                Button(action: {
                    router.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                  Text("Cart") .font(.headline) .fontWeight(.bold)
                Spacer()
               Text("     ")
            }.padding(.bottom,10)
                .padding(.leading, 10)
        }
    }
    
    private var headerView: some View {
     
        HStack {
            Button(action: {
                router.pop()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .font(.title2.bold())
            }
            Spacer()
            Text("Cart")
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Color.clear.frame(width: 24)
        }
        .padding()
    }

    private var footerView: some View {
            VStack(spacing: 15) {
                Divider()
                // ... delivery info row here ...
                
                Button(action: {
                    if isFormValid {
                        // Logic to clear cart and navigate to success
                        cartService.clearCart()
                        showingOrderAlert = true
                    }
                }) {
                    Text("Place Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        // 3. Dynamic Styling based on form status
                        .background(isFormValid ? Color.red : Color.gray.opacity(0.4))
                        .cornerRadius(15)
                }
                .disabled(!isFormValid) // 4. Disable user interaction
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .animation(.easeInOut, value: isFormValid) // Smooth transition
            }
        }
}

// MARK: - Row View
struct CartRowView: View {
    let menu: MenuModel
    @Environment(CartService.self) private var cartService

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Image using your imgUrl
            AsyncImage(url: URL(string: menu.imgUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 85, height: 85)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(menu.dishName) // Using dishName from your model
                    .font(.headline)
                Text(menu.dishSubTitle) // Using dishSubTitle
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("15-20 mins") // Static or add to model
                    .font(.caption)
                    .foregroundColor(.gray)
                
    
                
                // Formatted price
                Text("₹\(menu.prize, specifier: "%.2f")")
                    .font(.subheadline.bold())
            }
            
            Spacer()
            
            // Stepper
            HStack(spacing: 12) {
                Button(action: { cartService.remove(menu.id) }) {
                    Image(systemName: "minus").font(.system(size: 12, weight: .bold))
                }
                
                Text("\(cartService.items[menu.id] ?? 0)")
                    .font(.subheadline.bold())
                
                Button(action: { cartService.add(menu) }) {
                    Image(systemName: "plus").font(.system(size: 12, weight: .bold))
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .frame(height: 100)
    }
}
