import CoreLocation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let address: String
    let location: CLLocationCoordinate2D
    let score : Float
}

