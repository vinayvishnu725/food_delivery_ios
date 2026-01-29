//
//  dashboard.swift
//  login_ui
//
//  Created by Vinay H on 09/10/25.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Binding var selectedMainTab: Tab
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            if selectedMainTab == .home{
                DashboardView()
            } else if selectedMainTab == .settings{
                SettingsScreen()
            }
            
            BottomtabBar(selectedtab: $selectedMainTab)
        }
    }
    
    struct BottomtabBar: View {
        @Binding var selectedtab: Tab
        
        var body: some View {
            HStack{
                Button(action:{
                    selectedtab = .home
                }) {
                    VStack{
                        Image(systemName:selectedtab == .home ? "house.fill": "house")
                            .font(.title2)
                            .foregroundColor(Color.pink.opacity(0.8))
                        Text("Home").font(.caption2).foregroundColor(Color.pink.opacity(0.8))
                    }.frame(maxWidth: .infinity)
                }
                Button(action:{
                    selectedtab = .settings
                }) {
                    VStack{
                        Image(systemName: selectedtab == .settings ? "gearshape.fill": "gearshape")
                            .font(.title2).foregroundColor(Color.pink.opacity(0.8))
                        Text("Settings").font(.caption2).foregroundColor(Color.pink.opacity(0.8))
                    }.frame(maxWidth: .infinity)
                }
            }.padding(4)
                .background(Color.gray.opacity(0.1))
                .navigationBarBackButtonHidden(true)
        }
    }
}



