//
//  MapView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 16/04/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @State private var isDataLoaded = false
    @State private var selectedRestaurant: Restaurant? = nil // Variable para el restaurante seleccionado
    
    var body: some View {
        NavigationView { // Envuelve la vista en un NavigationView
            Map(coordinateRegion: $mapViewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil, annotationItems: mapViewModel.nearbyRestaurants) { restaurant in
                MapAnnotation(coordinate: restaurant.location) {
                    VStack {
                        let color: Color
                        if restaurant.score < 3 {
                            Image(systemName: "fork.knife.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        } else if restaurant.score >= 3 && restaurant.score <= 4 {
                            Image(systemName: "fork.knife.circle.fill")
                                .foregroundColor(.yellow)
                                .font(.title)
                        } else {
                            Image(systemName: "fork.knife.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        }
                        Text(restaurant.name)
                            .foregroundColor(.black)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .onTapGesture {
                        selectedRestaurant = restaurant // Establecer el restaurante seleccionado al hacer clic
                    }
                }
            }
            .sheet(item: $selectedRestaurant) { restaurant in
                RestaurantView(restaurant: restaurant) // Abrir la vista de detalle del restaurante cuando se selecciona
            }
            .onAppear {
                mapViewModel.filterRestaurants() // Filtro inicial (opcional)
            }
            .onReceive(restaurantViewModel.$restaurants) { restaurants in
                if !restaurants.isEmpty {
                    mapViewModel.checkIfLocationServicesIsEnabled()
                    mapViewModel.restaurantViewModel = restaurantViewModel
                    mapViewModel.filterRestaurants() // Filtrar después de que se obtienen los datos
                }
            }
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
