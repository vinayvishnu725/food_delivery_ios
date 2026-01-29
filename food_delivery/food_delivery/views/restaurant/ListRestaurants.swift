//
//  ListRestaurants.swift
//  login_ui
//
//  Created by Vinay H on 05/11/25.
//

import SwiftUI
import SwiftData

struct ListRestaurants: View{
    
    var body: some View {
        VStack {
            ListViewBackButton()
            RestaurantLists()
        } .navigationBarBackButtonHidden(true)
    }
}

struct ListViewBackButton: View {
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
              Text("Restaurants") .font(.headline) .fontWeight(.bold)
            Spacer()
           Text("     ")
        }.padding(.bottom,10)
            .padding(.leading, 10)
    }
}

struct RestaurantLists: View{
    @Environment(\.modelContext) var modelContext
    @State private var restaurants: [RestaurantModel] = []
    @State private var selectedRestaurant: RestaurantModel?
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(restaurants){restaurant in
                    RestaurantListTileView(restaurant: restaurant,
                                           onEdit: {
                        router.navigate(to: .addOrUpdateRestaurant(restaurant: restaurant))
                    },
                                           onDelete: {
                        let result = deleteRestaurant(modelContext: modelContext, hotel: restaurant)
                        alertMessage = result.1
                        showSuccessAlert = true
                        
                    },
                                           onAddMenu:  {
                        router.navigate(to: .addOrUpdateMenu(menuData: nil, restaurant: restaurant))
                    },
                                           onViewMenu:  {
                        router.navigate(to: .menuList(restaurant: restaurant))
                       
                    }
                    )
                }
                
            }
        } .onAppear{
            restaurants = fetchRestaurants(modelContext: modelContext)
        }.alert(isPresented: $showSuccessAlert){
            Alert(title:Text("Status"),message:Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}



struct RestaurantListTileView: View{
    let restaurant: RestaurantModel
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onAddMenu: () -> Void
    let onViewMenu: () -> Void
    
    var body: some View{
        VStack {
            HStack(spacing:16){
                AsyncImage(url: URL(string: restaurant.imgUrl)){
                    phase in switch phase{
                    case .empty:
                        Color.gray
                    case .success(let image):
                        image.resizable()
                            .frame(width: 75, height: 75)
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .foregroundColor(.pink)
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 75, height: 60)
                .cornerRadius(8)
                .clipped()
                VStack(alignment: .leading,spacing: 4){
                    Text(restaurant.hotelName)
                    Text(restaurant.shortDescription).font(.caption).foregroundColor(.gray)
                    Button(action:onAddMenu) {
                        HStack{
                            Text("Add Menu").foregroundColor(.pink).font(.caption)
                        }
                    }
                    .padding(.vertical,4)
                    
                        .padding(.horizontal,8)

                        .overlay(RoundedRectangle(

                            cornerRadius: 8

                        ).stroke(Color.pink, lineWidth: 1))
                    Button(action:onViewMenu) {
                        HStack{
                            Text("View Menus").foregroundColor(.white).font(.caption)
                        }
                    }.padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        
                        // Add a filled pink background
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.pink) // Use .fill() to create a solid background
                        )
                }
                Spacer()
                VStack {
                    Button(action:onEdit) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    Button(action:onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.pink)
                    }
                }
                
                
            }   .frame( height: 110)
                .cornerRadius(8)
                .clipped()
                .padding(10)
                .contentShape(Rectangle())
            
            
            Divider()
                .frame(height: 1)
                .background(Color.pink.opacity(0.3))
            
        }
        
        
    }
    
}


#Preview {
    ListRestaurants()
}
