//
//  BottomNavigationBar.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

struct BottomNavigationBar: View {
    @ObservedObject var cart: Cart
    @ObservedObject var restaurnatViewModel : RestaurantViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @StateObject var viewModel = FavoritesViewModel()
    

    var body: some View {
        // Aquí defines tu barra de navegación inferior
        TabView {
            // Cada elemento de TabView representa una pantalla en tu aplicación
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                }
            promotionsView()
                .tabItem {
                    Image(systemName: "percent")
                }
            
            MapView(restaurantViewModel: restaurnatViewModel,mapViewModel: mapViewModel,cart: cart)
                .tabItem {
                    Image(systemName: "storefront")
                }
            ordersView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                }
        }
        .accentColor(pinkColor) // Color de resaltado para los elementos seleccionados
    }
}
