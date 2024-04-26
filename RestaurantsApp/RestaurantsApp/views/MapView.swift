import SwiftUI
import MapKit
import Network

struct MapView: View {
    @StateObject var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @State private var isDataLoaded = false
    @ObservedObject var monitor = NetworkMonitor()
    @AppStorage("cachedRestaurants") var cachedRestaurants: Data?
    @State private var isConnected = true // Track network connection status

    var body: some View {
        Group{
            if isConnected { // Mostrar el mapa si hay conexión a internet
                Map(coordinateRegion: $mapViewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil, annotationItems: mapViewModel.nearbyRestaurants) { restaurant in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)) {
                        // Contenido de la anotación
                        VStack {
                            let color: Color
                            if restaurant.score < 3 {
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                Text(restaurant.name)
                                    .foregroundColor(.black)
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            } else if restaurant.score >= 3 && restaurant.score <= 4 {
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(.yellow)
                                    .font(.title)
                                Text(restaurant.name)
                                    .foregroundColor(.black)
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            } else {
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(.green)
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
                }
                .onAppear {
                    mapViewModel.filterRestaurants()
                }
                .onReceive(restaurantViewModel.$restaurants) { restaurants in
                    if !restaurants.isEmpty {
                        mapViewModel.checkIfLocationServicesIsEnabled()
                        mapViewModel.restaurantViewModel = restaurantViewModel
                        mapViewModel.filterRestaurants() // Filter after data is fetched
                    }
                }
            }else {
                VStack{
                    // Si no hay datos en caché, mostrar un mensaje
                    Text("No hay conexión a internet y no se encontraron datos en caché.")
                }
                
            }
        }
        
        .onReceive(monitor.$isConnected) { isConnected in
            // Update local state when network status changes
            self.isConnected = isConnected
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
