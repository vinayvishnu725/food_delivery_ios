//
//  SettingsScreen.swift
//  login_ui
//
//  Created by Vinay H on 05/11/25.
//

import SwiftUI
import SwiftData

struct SettingsScreen: View {
    var body: some View {
        VStack{
            ProfileSection()
            SettingsList()
        }
        .padding(.horizontal, 10)
        .frame(minHeight:0 ,maxHeight:  .infinity, alignment: .top)
    }
}

struct ProfileSection: View {
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors:[Color.pink, Color.pink.opacity(0.5)]), startPoint: .leading, endPoint: .trailing
            )
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .cornerRadius(8)
            
            HStack{
                Text("John cena ")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding(.leading,20)
                Spacer()
                ZStack{
                    Circle().fill(Color.pink).frame(width: 60, height:60)
                    Image(systemName: "person")
                        .foregroundColor(.white)
                        .frame(width: 50, height:50)
                        .font(.system(size:20))
                }.padding(.trailing, 20)
            }
            
        }
    }
}

struct SettingsList: View {
    @EnvironmentObject var router: Router
    var body: some View {
        
        VStack{
            Divider()
                .frame(height: 1)
                .background(Color.pink.opacity(0.3))
            Button(
                action: {
                    router.navigate(to: .addOrUpdateRestaurant(restaurant: nil))
                }
            ) {
                HStack{
                    Text("Add Restaurant")
                        .padding()
                        .foregroundColor(.pink)
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(.pink)
                }
            }
            Divider()
                .frame(height: 1)
                .background(Color.pink.opacity(0.3))
            Button(action:{
                router.navigate(to: .listRestaurant)
            }) {
                HStack{
                    Text("Restaurants List")
                        .padding()
                        .foregroundColor(.pink)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.pink)
                }
            }
            Divider()
                .frame(height: 1)
                .background(Color.pink.opacity(0.3))
            
            
            
        }
    }
}

#Preview {
    SettingsScreen()
}
