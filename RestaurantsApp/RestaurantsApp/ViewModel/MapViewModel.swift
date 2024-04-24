//
//  MapViewModel.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 18/04/24.
//
import SwiftUI
import MapKit


class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager?
    
    var restaurantViewModel : RestaurantViewModel? // ViewModel de restaurantes
    
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.601584309316319, longitude:-74.06600059206853),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
)
    @Published var nearbyRestaurants: [Restaurant] = []
    
    
    
    
    
    
    
    
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate=self
        }else{
            print("activate location")
        }
        
    }
    
    func checkLocationAuthorization(){
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("your location is restricted")
        case .denied:
            print("you have denied location permision")
        case .authorizedAlways, .authorizedWhenInUse:
            print("todo bien")
            region=MKCoordinateRegion(center: locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @unknown default:
            print("todo bien")

                    }
    }
    
    
    func filterRestaurants(){
        guard let viewModel = restaurantViewModel else {
                print("RestaurantViewModel is nil")
                return
            }
        
        
        guard let userLocation = locationManager?.location else {
                print("No se pudo obtener la ubicación del usuario")
                return
            }
                            // Filtrar los restaurantes cercanos basados en la ubicación del usuario
                            nearbyRestaurants = viewModel.restaurants.filter { restaurant in
                                let restaurantLocation = CLLocation(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
                                let distance = userLocation.distance(from: restaurantLocation)
                                // Si la distancia entre el usuario y el restaurante es menor o igual a 50 metros, lo incluimos
                                print(distance)
                                return distance <= 200
                            }
                        

        
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
    
}
