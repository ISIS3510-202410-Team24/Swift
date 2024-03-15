//
//  BottomNavigationBar.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
//

import Foundation
import SwiftUI

struct BottomNavigationBar: View {
    var body: some View {
        // Aquí defines tu barra de navegación inferior
        TabView {
            // Cada elemento de TabView representa una pantalla en tu aplicación
            homeView()
                .tabItem {
                    Image(systemName: "house")
                }
            promotionsView()
                .tabItem {
                    Image(systemName: "percent")
                }
            restaurantsView()
                .tabItem {
                    Image(systemName: "storefront")
                }
            ordersView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                }
        }
        .accentColor(.blue) // Color de resaltado para los elementos seleccionados
    }
}
