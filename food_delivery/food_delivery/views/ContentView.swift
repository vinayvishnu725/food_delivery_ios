//
//  ContentView.swift
//  login_ui
//
//  Created by Vinay H on 17/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = Router()
    @State private var selectedMainTab: Tab = .home

    var body: some View {
        NavigationStack(path: $router.path) {
            LoginScreen()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .homeScreen:
                        HomeScreen(selectedMainTab: $selectedMainTab)
                    case .listRestaurant:
                        ListRestaurants()
                    case .settings:
                        SettingsScreen()
                    case .addOrUpdateRestaurant(let restaurant):
                        AddUpdateRestaurant(existingHotel: restaurant)
                    case .restaurantDetails(let restaurant):
                        RestaurantDetailsScreen(restaurant: restaurant)
                    case .addOrUpdateMenu(let menuData, let restaurant):
                        AddUpdateMenuScreen(existingMenu: menuData, restaurant:restaurant)
                    case .menuList(let restaurant):
                        ListMenusScreen(
                            restaurant:restaurant
                        )
                    case .cartScreen: CartScreen()
                    }
                }
        }.environmentObject(router)
    }
}

//this ui contains API call as well
//struct ContentView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var alertMessage = ""
//    @State private var showSuccessAlert = false
//    @State private var navigationPath: Destination?
//    @State private var selectedMainTab: Tab = .home
//  
//    
//    var body: some View {
//        NavigationStack{
//            VStack (spacing:20){
//                Text("Welcome Vinay").font(.largeTitle).bold()
//                TextField("Email",text:$email).textFieldStyle(RoundedBorderTextFieldStyle())
//                SecureField("Password", text:$password).textFieldStyle(RoundedBorderTextFieldStyle())
//                Button("Login"){
//                                               
//                    print("Email: \(email), Password: \(password)")
//                    self.navigationPath = .dashboard
//                    if email == "Vinay@gmail.com" && password == "123456"{
//                        self.alertMessage = "Login Success"
//                        self.showSuccessAlert = true
//                       
//
//                    }else{
//                        self.alertMessage = "Invalid email or password"
//                        self.showSuccessAlert = true
//                    }
//                    
//                }.navigationDestination(item: $navigationPath) { destination in
//                    switch destination {
//                    case .dashboard:
//                        HomeScreen(selectedMainTab: $selectedMainTab)
//                    case .settings:
//                        SettingsScreen()
//                    case .addRestaurant:
//                        HomeScreen(selectedMainTab: $selectedMainTab)
//                    case .listRestaurant:
//                        HomeScreen(selectedMainTab: $selectedMainTab)
//                    case .restaurantDetails:
//                        EmptyView()
//                    }
//                }
//                
//                Button("get"){
//                    APIService.shared.fetcData(completion: { objects in
//                        guard let objects = objects else {
//                               print("No objects found.")
//                               return
//                           }
//
//                           for object in objects {
//                               print("ID: \(object.id ?? "N/A")")
//                               print("Name: \(object.name)")
//                               if let data = object.data {
//                                   for (key, value) in data {
//                                       print("  \(key): \(value)")
//                                   }
//                               } else {
//                                   print("  Data: nil")
//                               }
//                               print("-----")
//                           }
//                    })
//                }
//                
//                Button("post"){
//                    APIService.shared.postData { result in
//                        switch result {
//                        case .success(let message):
//                            self.alertMessage = message
//                            self.showSuccessAlert = true
//                        case .failure(let error):
//                            self.alertMessage = error.localizedDescription
//                            self.showSuccessAlert = true
//                        }
//                    }
//                }
//                
//            }.alert(isPresented: $showSuccessAlert){
//                Alert(title:Text("Status"),message:Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
//        }
//    }
//    
//}




#Preview {
    ContentView()
}
