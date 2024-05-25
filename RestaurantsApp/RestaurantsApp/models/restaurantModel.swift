import CoreLocation

struct Restaurant: Identifiable  {
    let id : String
    let name: String
    let category: String
    let address: String
    let location: CLLocationCoordinate2D
    let score : Float
    let menu : [String]
    let imageURL : URL
}

