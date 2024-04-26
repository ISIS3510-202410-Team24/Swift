import SwiftUI
import MapKit
import Network

struct MapView: View {
    @StateObject var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @State private var isDataLoaded = false
    @ObservedObject var monitor = NetworkMonitor()
    @AppStorage("cachedRestaurants") var cachedRestaurants: Data?
    @State private var connection = false

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if connection { // Mostrar el mapa si hay conexión a internet
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
                        self.connection = self.monitor.isConnected
                    }
                    .onReceive(restaurantViewModel.$restaurants) { restaurants in
                        if !restaurants.isEmpty {
                            mapViewModel.checkIfLocationServicesIsEnabled()
                            mapViewModel.restaurantViewModel = restaurantViewModel
                            mapViewModel.filterRestaurants() // Filter after data is fetched
                        }
                    }
                } else {
                    VStack {
                        // Si no hay datos en caché, mostrar un mensaje
                        Text("No hay conexión a internet y no se encontraron datos en caché.")
                    }
                }
            }
            
            // Leyenda
            VStack{
                HStack{
                    VStack(alignment: .trailing, spacing: 8) {
                        LegendItem(symbol: "fork.knife.circle.fill", color: .green, description: "Good")
                        LegendItem(symbol: "fork.knife.circle.fill", color: .yellow, description: " Mid")
                        LegendItem(symbol: "fork.knife.circle.fill", color: .red, description: " Bad")
                    }
                    .fixedSize(horizontal: false, vertical: true) // Tamaño mínimo vertical
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16)) // Ajustar el padding
                    .background(Color.gray.opacity(0.5)) // Hacer más transparente
                    .alignmentGuide(.trailing) { _ in
                        UIScreen.main.bounds.width - 10 // Alinear al borde derecho de la pantalla
                    }
                    .alignmentGuide(.top) { _ in
                        UIScreen.main.bounds.height - 50 // Subir el VStack
                    }

                    .padding() // Añadir padding general al VStack
                    
                }
            }
            
        }
        .onAppear {
            connection = monitor.isConnected
        }
        .onReceive(monitor.$isConnected) { isConnected in
            // Update local state when network status changes
            self.connection = isConnected
        }
    }
}

struct LegendItem: View {
    var symbol: String
    var color: Color
    var description: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: symbol)
                .foregroundColor(color)
            Text(description)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
