import CoreLocation

struct Restaurant: Identifiable, Codable {
    let id = UUID()
    let name: String
    let category: String
    let address: String
    let location: Coordinate
    let score: Float
}




struct Coordinate: Codable {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // Para convertir de CLLocationCoordinate2D a Coordinate
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    // Para convertir de Coordinate a CLLocationCoordinate2D
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
