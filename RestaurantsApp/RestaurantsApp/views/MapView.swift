//
//  MapView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 16/04/24.
//

import SwiftUI
import MapKit



import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @State private var isDataLoaded = false

    var body: some View {
        Map(coordinateRegion: $mapViewModel.region,interactionModes: .all, showsUserLocation: true,userTrackingMode: nil,annotationItems: mapViewModel.nearbyRestaurants) { restaurant in
            MapAnnotation(coordinate: restaurant.location){
                VStack {
                               Image(systemName: "fork.knife.circle.fill")
                                   .foregroundColor(.blue)
                                   .font(.title)
                               Text(restaurant.name)
                                   .foregroundColor(.black)
                                   .font(.caption)
                                   .padding(4)
                                   .background(Color.white)
                                   .cornerRadius(8)
                           }
            }
            
        }
        .onAppear {
          mapViewModel.filterRestaurants() // Initial filter (optional)
        }
        .onReceive(restaurantViewModel.$restaurants) { restaurants in
          if !restaurants.isEmpty {
              mapViewModel.checkIfLocationServicesIsEnabled()
              mapViewModel.restaurantViewModel=restaurantViewModel
              mapViewModel.filterRestaurants() // Filter after data is fetched
          }
        }
    }
}






#Preview {
    MapView()
}
