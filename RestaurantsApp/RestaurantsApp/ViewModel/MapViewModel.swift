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
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.601584309316319, longitude:-74.06600059206853),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
)
    
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
            region=MKCoordinateRegion(center: locationManager.location!.coordinate,span:MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @unknown default:
            break
        }
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
    
}
