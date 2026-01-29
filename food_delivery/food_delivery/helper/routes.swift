//
//  route.swift
//  food_delivery
//
//  Created by Vinay H on 13/11/25.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func pop() {
        if !path.isEmpty { path.removeLast() }
    }

    func reset() {
        path = NavigationPath()
    }
}
