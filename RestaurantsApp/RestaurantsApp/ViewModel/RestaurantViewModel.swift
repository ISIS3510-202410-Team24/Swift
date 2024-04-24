import FirebaseFirestore
import CoreLocation
import SwiftUI

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    
    private var db = Firestore.firestore()
    
    init() {
        fetchRestaurants()
    }
    
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
                       let score = data["calificacion"] as? Float,
                       let location = data["ubicacion"] as? GeoPoint {
                        let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        
                        
                        let restaurant = Restaurant(name: name, category: category, address: address, location: coordinates, score: score)
                        fetchedRestaurants.append(restaurant)
                    }
                }
                self.restaurants = fetchedRestaurants
            }
        }
    }
}
