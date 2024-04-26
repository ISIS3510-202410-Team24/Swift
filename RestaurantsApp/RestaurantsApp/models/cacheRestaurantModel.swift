import CoreLocation

struct CacheRestaurant: Identifiable, Encodable, Decodable {
    let id = UUID()
    let name: String
    let category: String
    let address: String
    let location: CLLocationCoordinate2D
    let score: Float
    
    enum CodingKeys: String, CodingKey {
        case name, category, address, location, score
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        address = try container.decode(String.self, forKey: .address)
        score = try container.decode(Float.self, forKey: .score)
        
        // Decodificar la ubicación como un diccionario de latitud y longitud
        let locationDictionary = try container.decode([String: Double].self, forKey: .location)
        guard let latitude = locationDictionary["latitude"], let longitude = locationDictionary["longitude"] else {
            throw DecodingError.dataCorruptedError(forKey: .location, in: container, debugDescription: "Invalid location data")
        }
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(address, forKey: .address)
        try container.encode(score, forKey: .score)
        
        // Codificar la ubicación como un diccionario de latitud y longitud
        try container.encode(["latitude": location.latitude, "longitude": location.longitude], forKey: .location)
    }
}
