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
    
    var body: some View {
        Map(coordinateRegion: $mapViewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil, annotationItems: mapViewModel.nearbyRestaurants) { restaurant in
            MapAnnotation(coordinate: restaurant.location){
                VStack {
                    let color: Color
                    if restaurant.score < 3 {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(restaurant.name)
                            .foregroundColor(.black)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(8)
                    } else if restaurant.score >= 3 && restaurant.score <= 4 {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(.yellow)
                            .font(.title)
                        Text(restaurant.name)
                            .foregroundColor(.black)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(.green)
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
        }
        .onAppear {
            mapViewModel.filterRestaurants() // Initial filter (optional)
        }
        .onReceive(restaurantViewModel.$restaurants) { restaurants in
            if !restaurants.isEmpty {
                mapViewModel.checkIfLocationServicesIsEnabled()
                mapViewModel.restaurantViewModel = restaurantViewModel
                mapViewModel.filterRestaurants() // Filter after data is fetched
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
