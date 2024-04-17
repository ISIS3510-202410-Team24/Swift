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
    @StateObject var viewModel = RestaurantViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.601584309316319, longitude:-74.06600059206853),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.restaurants) { restaurant in
            MapMarker(coordinate: restaurant.location, tint: .blue)
        }
        .onAppear {
            viewModel.fetchRestaurants()
        }
        .navigationTitle("Mapa de Restaurantes")
    }
}




#Preview {
    MapView()
}
