//
//  AddOrUpdateMenuScreen.swift
//  food_delivery
//
//  Created by Vinay H on 14/11/25.
//

import SwiftUI
import SwiftData

struct AddUpdateMenuScreen: View {
    var existingMenu: MenuModel?
    var restaurant: RestaurantModel
    var body: some View {
        VStack {
            MenuBackButton()
            MenuFormView(existingMenu: existingMenu, restaurant: restaurant)
        } .navigationBarBackButtonHidden(true)
    }
}

struct MenuBackButton: View {
    @EnvironmentObject var router: Router
    @State private var selectedMainTab: Tab = .settings
    
    
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
        }.padding(.bottom,10)
            .padding(.leading, 10)
    }
}


struct MenuFormView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var menuName: String = "Breakfast"
    @State var dishName: String = ""
    @State var rating: Double = 5.0
    @State var dishSubTitle: String = ""
    @State var items: String = ""
    @State var imgUrl: String = ""
    @State var prize: Double = 0.0
    
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    
    var existingMenu: MenuModel?
    var restaurant: RestaurantModel
    
    let options = ["Breakfast", "Lunch", "Dinner", "Desserts", "Drinks"]
    
    var body: some View {
        VStack {
            Form{
                Section(header: Text("Menu Information")) {
                    VStack(alignment: .leading) {
                                Text("Select Menu")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Picker("Menu", selection: $menuName) {
                                    ForEach(options, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(.menu) // This creates the dropdown behavior
                                .padding(.horizontal)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
            
                    TextField("Dish name", text: $dishName)
                    TextField("Dish subtitle", text: $dishSubTitle)
                    TextField("Rating", value: $rating, format: .number)
                    TextField("Items", text: $items)
                    TextField("Image Url", text: $imgUrl)
                    TextField("Prize", value: $prize, format: .number)
                }
            }
            
            
            Button(existingMenu == nil ? "Add Menu" : "Update Menu") {
                guard !menuName.isEmpty,
                      !dishName.isEmpty,
                      rating>0,
                      !dishSubTitle.isEmpty,
                      !items.isEmpty,
                      !imgUrl.isEmpty,
                      prize>0.0
                        
                else {
                    print("All fields are required.")
                    self.showSuccessAlert = true
                    self.alertMessage = "All fields are required."
                    return
                }
                
                
                if let menuModel = self.existingMenu {
                    let updated = MenuModel(
                        hotelId: restaurant.id,
                        menuName: menuName,
                        dishName: dishName,
                        dishSubTitle: dishSubTitle,
                        items: items,
                        rating: rating,
                        imgUrl: imgUrl,
                        prize: prize
                    )
                    
                    
                    let result = updateMenu(modelContext: modelContext, menuData: menuModel, with: updated)
                    
                    let restaurants =  fetchAllMenu(modelContext: modelContext)
                    alertMessage = result.1
                    showSuccessAlert = true
                    
                    if result.0 {
                        // Success logic, e.g. navigate or reset form
                        print("✅ updated successfully")
                    } else {
                        // Failure logic, e.g. highlight field or show error
                        print("❌ Duplicate entry")
                    }
                    print(restaurants.count)
                    
                    
                } else {
                    let newMenu  = MenuModel(
                        hotelId: restaurant.id,
                        menuName: menuName,
                        dishName: dishName,
                        dishSubTitle: dishSubTitle,
                        items: items,
                        rating: rating,
                        imgUrl: imgUrl,
                        prize: prize
                        
                    )
                    
                    let result =  addMenu(modelContext: modelContext, menuData:  newMenu)
                    let fetchedMenu =  fetchAllMenu(modelContext: modelContext)
                    alertMessage = result.1
                    showSuccessAlert = true
                    
                    if result.0 {
                        // Success logic, e.g. navigate or reset form
                        print("✅Addedsuccessfully \(fetchedMenu.count)")
                    } else {
                        // Failure logic, e.g. highlight field or show error
                        print("❌ Duplicate entry")
                    }
                   
                }
                
                
            }
            .foregroundColor(.pink)
            .onAppear{
                if let menuData = existingMenu {
                    menuName = menuData.menuName
                    dishName = menuData.dishName
                    rating = menuData.rating
                    dishSubTitle = menuData.dishSubTitle
                    items = menuData.items
                    imgUrl = menuData.imgUrl
                    prize = menuData.prize
                }
            }
        }
        .alert(isPresented: $showSuccessAlert){
            Alert(title:Text("Status"),message:Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        
        
    }
}


