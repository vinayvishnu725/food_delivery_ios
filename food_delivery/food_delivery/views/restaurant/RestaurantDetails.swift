//
//  RestaurantDetails.swift
//  food_delivery
//
//  Created by Vinay H on 11/11/25.
//

import SwiftUI

struct RestaurantDetailsScreen: View {
    let restaurant: RestaurantModel
    
    @Environment(CartService.self) private var cart
    var body: some View {
        ZStack{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                RestaurantHeaderView(restaurant:restaurant)
                // Restaurant Info
                HStack(alignment: .top) {
                    RestaurantDetails(restaurant:restaurant)
                    Spacer()
                    RatingBox()
                }.padding(.horizontal, 20)
                    .padding(.top, 12)
                
                FoodStandards()
                
                Divider()
                vegOrNonVegTiles()
                ListMenus(restaurant:restaurant)
                Spacer()
                
                
            }
        }
            
            //show success toast
            if cart.showSuccessToast {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text("Added to cart")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(25)
                        .padding(.bottom, 50) // Adjust based on your bottom bar
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
    }
        .navigationBarBackButtonHidden(true)
        
    }
}


struct RestaurantDetails: View {
    let restaurant: RestaurantModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(restaurant.hotelName)
                .font(.title)
            
            Text(restaurant.shortDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Sector 87, Gurgaon")
                .font(.caption)
                .foregroundColor(.gray)
            
            RichTextDisplay()
            
            
            
        }
        
    }
}

struct FoodStandards: View {
    var body: some View {
        HStack{
            LabeledIconBox(icon:"checkmark.shield", text:"HYGIENE RATING",subTitle: "4 - VERY GOOD", iconColor: .blue)
            LabeledIconBox(text: "INGREDIENT QUALITY",
                           subTitle: "Hyperpure inside",
                           iconColor: .green)
        }.padding(.leading,20)
            .padding(.top,10)
            .padding(.bottom,10)
    }
    
}

struct vegOrNonVegTiles: View {
    @State private var isVegOnly = false
    @State private var isEggOnly = false
    var body: some View {
        HStack(spacing: 20) {
            // Veg Only Filter
            Toggle(isOn: $isVegOnly) {
                Text("Veg only")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .scaleEffect(0.7)
            .fixedSize() // Prevents the toggle from taking up too much space

            // Egg Filter
            Toggle(isOn: $isEggOnly) {
                Text("Egg")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .toggleStyle(SwitchToggleStyle(tint: .yellow))
            .scaleEffect(0.7)
            .fixedSize()

            Spacer()

            // Search Button
            Button(action: {
                print("Search tapped")
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(6)
                    .background(
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            .shadow(radius: 1)
                    )
            }
        }
        .padding(.horizontal, 10)
            .padding(.top, 8)
    }
}



struct LabeledIconBox: View {
    let icon: String               // SF Symbol name for the icon
    let text: String               // The label text
    let subTitle: String
    let cornerRadius: CGFloat      // Box corner radius
    let iconColor: Color         // icon color
    let borderWidth: CGFloat       // Outline width
    let iconSize: CGFloat          // Icon size
    
    init(
        icon: String = "leaf",
        text: String,
        subTitle: String,
        cornerRadius: CGFloat = 8,
        iconColor: Color = .gray,
        borderWidth: CGFloat = 1,
        iconSize: CGFloat = 18
    ) {
        self.icon = icon
        self.text = text
        self.subTitle = subTitle
        self.cornerRadius = cornerRadius
        self.iconColor = iconColor
        self.borderWidth = borderWidth
        self.iconSize = iconSize
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(iconColor)
            
            // Wrapping text
            VStack(alignment: .leading) {
                Text(text)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true) // allow multi-line wrap
                    .multilineTextAlignment(.leading)
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true) // allow multi-line wrap
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.gray.opacity(0.2), lineWidth: borderWidth)
        )
    }
}



struct RatingBox: View {
    var body: some View {
        VStack(spacing: 0) {
            // Top half
            Text("4.2")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 35) // half height
                .background(Color.green)
            
            // Bottom half
            VStack(spacing: 0) {
                Text("1,234")
                    .font(.caption)
                    .foregroundColor(.black)
                Text("reviews")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 35) // half height
            .background(Color.white)
        }
        .frame(width: 60, height: 70) // overall box size
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}


struct RichTextDisplay: View {
    var body: some View {
        Text(makeAttributed())
            .lineSpacing(4)
            .multilineTextAlignment(.leading)
    }
    
    private func makeAttributed() -> AttributedString {
        var time = AttributedString("Open now – ")
        time.font = .system(.caption)
        time.foregroundColor = .blue
        
        var timings = AttributedString("11am - 11pm today")
        timings.font = .system(.caption, weight: .bold)
        timings.foregroundColor = .gray
        
        let all = time + timings
        
        return all
    }
}


struct RestaurantHeaderView: View {
    let restaurant: RestaurantModel
    @Environment(\.dismiss) var dismiss
    @Environment(CartService.self) private var cart
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background Image
            AsyncImage(url:  URL(string: restaurant.imgUrl) ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                    //                        .ignoresSafeArea(edges: .top)
                default:
                    Color.gray.opacity(0.2)
                        .frame(height: 250)
                    //                        .ignoresSafeArea(edges: .top)
                }
            }
            
            // Black gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.9), Color.clear]),
                startPoint: .top,
                endPoint: .center
            )
            .frame(height: 250)
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(20)
            
            // Top-right icons
            HStack(spacing: 16) {
                Button(action: {
                    // Save action
                }) {
                    Image(systemName: "bookmark")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                
                Button(action: {
                    router.navigate(to: .cartScreen)
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(5)
                        
                        // Only show badge if there are items
                        if cart.totalQuantity > 0 {
                            Text("\(cart.totalQuantity)")
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(Color.red)
                                .clipShape(Circle())
                                // Adjust position so it sits on the corner of the icon
                                .offset(x: 8, y: -5)
                        }
                    }
                }
            }
            .padding(.top, 16)
            .padding(.trailing, 16)
        }
    }
}


struct OfferTile: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct NavAction: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
            Text(label)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ListMenus: View{
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
                    MenuListView(menu: menu)
                }
                
            }
        } .onAppear{
            guard let hotelId = restaurant?.id else {
                print("No restaurant ID found")
                return
            }
            menus = fetchMenuByHotelId(modelContext: modelContext, hotelId: hotelId)
        }
    }
}



struct MenuListView: View{
    let menu: MenuModel
    @Environment(CartService.self) private var cart
    @State private var showClearCartAlert = false
    @State private var addToCartSuccess = false
    
    var body: some View{
        VStack {
            HStack(spacing:16){
                AsyncImage(url: URL(string: menu.imgUrl)){
                    phase in switch phase{
                    case .empty:
                        Color.gray
                    case .success(let image):
                        image.resizable()
                            .frame(width: 75, height: 85)
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 85)
                            .foregroundColor(.pink)
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 75, height: 85)
                .cornerRadius(8)
                .clipped()
                VStack(alignment: .leading,spacing: 4){
                    Text(menu.dishName)
                    Text(menu.dishSubTitle).font(.caption).foregroundColor(.gray)
                    HStack(spacing: 8) {
                        // Star Row
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: "star.fill")
                                    .foregroundColor(index <= 4 ? .yellow : .gray.opacity(0.3))
                                    .font(.system(size: 10)) // Adjust size to match your UI
                            }
                        }
                        
                        // Rating Count Text
                        Text("123 ratings")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(menu.prize, format: .currency(code: "INR")).font(.caption).foregroundColor(.black)
                    Text(menu.items).font(.caption).foregroundColor(.black)
                }
                Spacer()
                Button(
                    action: {
                        if cart.currentRestaurantID != nil && cart.currentRestaurantID != menu.hotelId {
                            // Trigger a state variable to show an Alert
                            showClearCartAlert = true
                        } else {
                            cart.add(menu)
                            addToCartSuccess = true
                        }
                    }
                ) {
                    HStack(spacing: 8) {
                        Text("ADD")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black) // Typical pinkish-red accent
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                
                
                
            }   .frame( height: 105)
                .cornerRadius(8)
                .clipped()
                .padding(10)
                .contentShape(Rectangle())
            
            
            Divider()
                .frame(height: 1)
                .background(Color.pink.opacity(0.3))
            
        }.alert("Replace cart items?", isPresented: $showClearCartAlert) {
            Button("Clear & Add", role: .destructive) {
                cart.clearCart()
                cart.add(menu)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your cart contains dishes from another restaurant. Adding this will clear your current selection.")
        }
        
        
    }
}


//#Preview {
//    RestaurantDetailsScreen(restaurant: RestaurantModel)
//}
