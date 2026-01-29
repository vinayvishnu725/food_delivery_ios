//
//  dashBoardSecreen.swift
//  login_ui
//
//  Created by Vinay H on 05/11/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @State private var searchString: String = ""
    @State private var selectedTabIndex = 0
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(alignment: .leading, spacing: 14){
                VStack (alignment: .leading, spacing:14){
                    Spacer().frame(height: 12)
                    HStack(alignment: .bottom){
                        Image(systemName: "mappin").foregroundColor(.orange).font(.system(size:20))
                        Text("Basin, New Zealand").foregroundColor( .red).font(.system(size:20, weight: .bold))
                        Spacer()
                        ZStack{
                            Circle().fill(Color.red).frame(width: 40, height:40)
                            Image(systemName: "person").foregroundColor(.white).font(.system(size:20))
                        }
                    }.frame(maxWidth:  .infinity, alignment: .bottom)
                    
                    TextField(
                        "Search for restaurants, cruisinee, hotels...", text:$searchString
                    ).padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    
                    HStack{
                        TabButton(title:"Delivery", index:0, selectedIndex: $selectedTabIndex)
                        TabButton(title:"Self Pickup", index:1, selectedIndex: $selectedTabIndex)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    
                    if selectedTabIndex == 0{
                        HorizontalImageCarouselView()
                    }else{
                        ImageCarouselView()
                    }
                    
                    TrendingFilters()
                    HorizontalMainFilters()
                    RestaurantListView()
                }
                .padding(.horizontal, 10)
                .frame(minHeight:0 ,maxHeight:  .infinity, alignment: .top)
                
            }
        }
    }
}




struct TabButton: View {
    let title: String
    let index: Int
    @Binding var selectedIndex: Int
    
    
    var body: some View{
        Button(
            action: {
                selectedIndex = index
            }
        ) {
            Text(self.title)
                .foregroundColor(.black )
                .padding(.vertical, 8)
                .padding(.horizontal, 40)
                .background(selectedIndex == index ? Color.white: Color.clear)
                .cornerRadius(8)
        }
    }
}

struct HorizontalImageCarouselView: View {
    let imageUrls = ["https://img.pikbest.com/origin/06/15/68/14ZpIkbEsTPcv.jpg!f305cw","https://coreldrawdesign.com/resources/previews/preview-restaurant-food-poster-banner-download-from-coreldrawdesign-1631023169.webp","https://cdn.dribbble.com/userupload/10758065/file/original-681d79ac61e48bba16e1c8f9088b567a.png?resize=752x&vertical=center","https://d3jbu7vaxvlagf.cloudfront.net/small/v2/category_media/image_17271614481315.jpeg",
    ]
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack(){
                ForEach(imageUrls, id: \.self) { urlString in
                    AsyncImage(url: URL(string: urlString)!){ phase in
                        switch phase{
                        case .empty:
                            ProgressView()
                                .frame(width:250, height:175)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width:250, height:175)
                                .clipped()
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width:250, height:175)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                            
                        }
                    }
                }
            }
        }
        .frame(height: 175)
    }
    
}



struct ImageCarouselView: View {
    let images = ["https://d3jbu7vaxvlagf.cloudfront.net/small/v2/category_media/image_17271614481315.jpeg",
                  "https://img.freepik.com/free-psd/food-social-media-promotion-banner-post-design-template_202595-325.jpg?semt=ais_hybrid&w=740&q=80",]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { urlString in
                AsyncImage(url: URL(string: urlString)!){ phase in
                    switch phase{
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    case .success(let image):
                        image
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .clipped()
                            .cornerRadius(20)
                            .padding(.horizontal)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }.frame(height: 250)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}


struct TrendingFilters: View{
    
    var body: some View {
        HStack(spacing: 8){
            TrendingFilter(icon: "rocket_icon", title: "Express Delivery")
            TrendingFilter(icon: "safe_badge_icon", title: "Safely Sealed")
            TrendingFilter(icon: "offers_icon", title: "Great Offers")
            TrendingFilter(icon: "dish_icon", title: "New Arrivals")
            TrendingFilter(icon: "trending_heart", title: "Trending Places")
        }
    }
}

struct TrendingFilter: View {
    let icon:  String
    let title: String
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            .frame( height:90)
            .frame(maxWidth: .infinity)
            .overlay(
                VStack(spacing:6){
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height:40)
                    
                    Text(title).font(.system(size: 12)).multilineTextAlignment(.center)
                }
            )
        
    }
}

struct HorizontalMainFilters: View {
    let filters = ["Filter","Rating","Chinese","Indian","North", "South"]
    let selectedIndex = 3
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing: 8){
                ForEach(Array(filters.enumerated()), id: \.element) { index, title in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedIndex == index ? Color.pink : Color.clear)
                        .stroke(selectedIndex == index ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                        .frame(height:30)
                        .frame(width: 60)
                        .overlay(
                            VStack(spacing:6){
                                
                                Text(title).font(.system(size: 14)).multilineTextAlignment(.center)
                                    .foregroundColor(selectedIndex == index ? .white :.gray)
                            }
                        )
                }
            }
        }
        .frame(height: 30)
    }
    
}

struct RestaurantListView: View {
    @Query private var restaurants: [RestaurantModel]
    var body: some View {
        LazyVStack(spacing:12){
            ForEach(restaurants){
                restaurant in RestaurantRow(restaurant: restaurant)
            }
        }
    }
}

struct RestaurantRow: View {
    var restaurant: RestaurantModel
    @EnvironmentObject var router: Router
    var body: some View {
        
        Button(action:{
            router.navigate(to: .restaurantDetails(restaurant: restaurant))
        }){
            HStack(alignment:.top, spacing: 16){
                AsyncImage(url: URL(string: restaurant.imgUrl)) { phase in
                    switch phase {
                    case .empty:
                        // While loading
                        Color.gray.opacity(0.3)
                        
                    case .success(let image):
                        // Image loaded successfully
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .failure(_):
                        // Failed to load
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.pink)
                        
                    @unknown default:
                        // Future-proof fallback
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .clipped()
                
                
                VStack(alignment:.leading, spacing: 2){
                    Text(restaurant.hotelName)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.8))
                    Text(restaurant.shortDescription)
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.8))
                    Text("₹\(restaurant.pricePerHead) per head | \(restaurant.avgDeliveryTime) mins" )
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(restaurant.mainOffer)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(restaurant.rating, specifier: "%.1f")")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(2)
                    .background(
                        Color.green
                    ).cornerRadius(4)
            }.padding(.vertical, 8)
            
            
        }
    }
}
