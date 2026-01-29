//
//  ListMenus.swift
//  food_delivery
//
//  Created by Vinay H on 27/01/26.
//

import SwiftUI
import SwiftData

struct ListMenusScreen: View{
    var restaurant: RestaurantModel
    var body: some View {
        VStack {
            ListViewMenuBackButton()
            MenuLists(restaurant:restaurant)
        } .navigationBarBackButtonHidden(true)
    }
}

struct ListViewMenuBackButton: View {
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
              Text("Menus") .font(.headline) .fontWeight(.bold)
            Spacer()
            Text("     ")
        }.padding(.bottom,10)
            .padding(.leading, 10)
    }
}

struct MenuLists: View{
    @Environment(\.modelContext) var modelContext
    @State private var menus: [MenuModel] = []
    @State private var selectedMenu: MenuModel?
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    @EnvironmentObject var router: Router
    var restaurant: RestaurantModel?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(menus){menu in
                    MenuListTileView(menu: menu,
                                           onEdit: {
                    },
                                           onDelete: {
                        
                    },
                                           onAddMenu:  {
                    })
                }
                
            }
        } .onAppear{
            guard let hotelId = restaurant?.id else {
                print("No restaurant ID found")
                return
            }
            menus = fetchMenuByHotelId(modelContext: modelContext, hotelId: hotelId)
        }.alert(isPresented: $showSuccessAlert){
            Alert(title:Text("Status"),message:Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}



struct MenuListTileView: View{
    let menu: MenuModel
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onAddMenu: () -> Void
    
    var body: some View{
        VStack {
            HStack(spacing:16){
                AsyncImage(url: URL(string: menu.imgUrl)){
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
                    Text(menu.dishName)
                    Text(menu.dishSubTitle).font(.caption).foregroundColor(.gray)
                    Text(menu.items).font(.caption).foregroundColor(.gray)
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
                
                
            }   .frame( height: 85)
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
