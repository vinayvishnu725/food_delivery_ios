//
//  add_update_restaurant.swift
//  login_ui
//
//  Created by Vinay H on 05/11/25.
//

import SwiftUI
import SwiftData

struct AddUpdateRestaurant: View {
    var existingHotel: RestaurantModel?
    var body: some View {
        VStack {
            BackButton(existingHotel: existingHotel)
            FormView(existingHotel: existingHotel)
        } .navigationBarBackButtonHidden(true)
    }
}


struct BackButton: View {
    @EnvironmentObject var router: Router
    @State private var selectedMainTab: Tab = .settings
    var existingHotel: RestaurantModel?
    
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

struct FormView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var hotelName: String = ""
    @State var shortDescription: String = ""
    @State var rating: Double = 5.0
    @State var avgDeliveryTime: String = ""
    @State var pricePerHead: String = ""
    @State var mainOffer: String = ""
    @State var imgUrl: String = ""
    
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    
    var existingHotel: RestaurantModel?
    var body: some View {
        
        VStack {
            Form{
                Section(header: Text("Restaurant Information")) {
                    TextField("Restaurant name", text: $hotelName)
                    TextField("Short description", text: $shortDescription)
                    TextField("Rating", value: $rating, format: .number)
                    TextField("Avg delivery time", text: $avgDeliveryTime)
                    TextField("Price per head", text: $pricePerHead)
                    TextField("Main offer", text: $mainOffer)
                    TextField("Image Url", text: $imgUrl)
                }
            }
            Button(existingHotel == nil ? "Add Restaurant" : "Update Restaurant") {
                guard !hotelName.isEmpty,
                      !shortDescription.isEmpty,
                      rating>0,
                      !avgDeliveryTime.isEmpty,
                      !mainOffer.isEmpty,
                      !pricePerHead.isEmpty,
                      !imgUrl.isEmpty
                else {
                    print("All fields are required.")
                    self.showSuccessAlert = true
                    self.alertMessage = "All fields are required."
                    return
                }
                
                
                if let existingModel = self.existingHotel {
                    let updated = RestaurantModel(
                           hotelName: hotelName,
                           shortDescription: shortDescription,
                           rating: rating,
                           avgDeliveryTime: avgDeliveryTime,
                           pricePerHead: pricePerHead,
                           mainOffer: mainOffer,
                           imgUrl: imgUrl
                       )
                    
                    
                    let result = updateRestaurant(modelContext: modelContext, hotel: existingModel, with: updated)
                    
                    let restaurants =  fetchRestaurants(modelContext: modelContext)
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
                    let newHotel  = RestaurantModel(
                        hotelName: hotelName,
                        shortDescription: shortDescription,
                        rating: rating,
                        avgDeliveryTime: avgDeliveryTime,
                        pricePerHead: pricePerHead,
                        mainOffer: mainOffer,
                        imgUrl: imgUrl
                    )
                    
                    let result =  addRestaurant(modelContext: modelContext, hotel: newHotel)
                    let restaurants =  fetchRestaurants(modelContext: modelContext)
                    alertMessage = result.1
                    showSuccessAlert = true
                    
                    if result.0 {
                        // Success logic, e.g. navigate or reset form
                        print("✅ Added successfully")
                    } else {
                        // Failure logic, e.g. highlight field or show error
                        print("❌ Duplicate entry")
                    }
                    print(restaurants.count)
                }
                
                
            }
            .foregroundColor(.pink)
            .onAppear{
                if let hotel = existingHotel {
                    hotelName = hotel.hotelName
                    shortDescription = hotel.shortDescription
                    rating = hotel.rating
                    avgDeliveryTime = hotel.avgDeliveryTime
                    mainOffer = hotel.mainOffer
                    pricePerHead = hotel.pricePerHead
                    imgUrl = hotel.imgUrl
                }
            }
        }
        .alert(isPresented: $showSuccessAlert){
            Alert(title:Text("Status"),message:Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        
        
    }
}

#Preview {
    AddUpdateRestaurant()
}
