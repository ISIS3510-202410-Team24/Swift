//
//  MapView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 16/04/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var restaurantViewModel : RestaurantViewModel
    @ObservedObject var mapViewModel : MapViewModel
    @State private var isDataLoaded = false
    @State private var selectedRestaurant: Restaurant? = nil // Variable para el restaurante seleccionado
    @State private var showAlert = false // Estado para controlar la visibilidad de la alerta
    @ObservedObject var cart: Cart

    
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
                RestaurantView(restaurant: restaurant,cart: cart ) // Abrir la vista de detalle del restaurante cuando se selecciona
            }
            .onAppear {
                check()
                if Reachability.isConnectedToNetwork() {
                    mapViewModel.filterRestaurants()
                } else {
                    // Mostrar el mensaje de falta de conectividad
                    self.showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                        Alert(title: Text("No Internet Connection"), message: Text("Please check your internet connection and try again."), dismissButton: .default(Text("OK")))
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
    
    func check(){
        print("entre al on apper")
    }
}


//struct MapView_Previews: PreviewProvider {
  //  static var previews: some View {
    //    MapView()
    //}
//}
