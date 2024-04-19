//
//  RestaurantViewModel.swift
//  RestaurantsApp
//
//  Created by Estudiantes on 20/03/24.
//

import FirebaseFirestore
import CoreLocation

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    
    private var db = Firestore.firestore()
    
    func fetchRestaurants() {
        db.collection("restaurantes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var fetchedRestaurants: [Restaurant] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let name = data["nombre"] as? String,
                       let category = data["categoria"] as? String,
                       let address = data["direccion"] as? String,
                       let location = data["ubicacion"] as? GeoPoint {
                        let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        print(coordinates)
                        let restaurant = Restaurant(name: name, category: category, address: address, location: coordinates)
                        fetchedRestaurants.append(restaurant)
                    }
                }
                self.restaurants = fetchedRestaurants
            }
        }
    }

}

