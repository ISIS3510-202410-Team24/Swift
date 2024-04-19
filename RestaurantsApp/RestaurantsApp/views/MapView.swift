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
    @StateObject var RestaurantviewModel = RestaurantViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    

    
    var body: some View {
        Map(coordinateRegion: $mapViewModel.region,interactionModes: .all, showsUserLocation: true,userTrackingMode: nil,annotationItems: RestaurantviewModel.restaurants) { restaurant in
            MapAnnotation(coordinate: restaurant.location){
                VStack {
                               Image(systemName: "mappin")
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
        RestaurantviewModel.fetchRestaurants()
          mapViewModel.checkIfLocationServicesIsEnabled()
      }
      .navigationTitle("Mapa de Restaurantes")
    }
}




#Preview {
    MapView()
}
