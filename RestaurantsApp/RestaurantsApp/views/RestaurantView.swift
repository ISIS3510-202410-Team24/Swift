import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct RestaurantView: View {
    var restaurant: Restaurant
    @State private var menuItems: [MenuItem] = [] // Estado para almacenar los elementos del menú
    @State private var showAlert = false // Estado para controlar la visibilidad de la alerta
    @ObservedObject var cart = Cart() // ObservedObject para el carrito


    var body: some View {
        VStack(spacing: 10) {
            
            Text(restaurant.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .multilineTextAlignment(.center)
            
            HStack {
                // Mostrar la imagen del restaurante con caché
                WebImage(url: restaurant.imageURL){image in
                    image.resizable()
                }placeholder: {
                    ProgressView()
            }
                    .onSuccess { image, data, cacheType in
                        // Success block you can use to perform any actions
                    }
                    .resizable()
                    .indicator(.activity) // Show activity indicator while loading
                    .transition(.fade(duration: 0.5)) // Fade transition
                    .frame(height: 200) // Altura fija para la imagen
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Address: \(restaurant.address)")
                        .font(.subheadline)
                        .fontWeight(.regular)
                    
                    Text("Score: \(restaurant.score, specifier: "%.1f")")
                        .font(.subheadline)
                        .fontWeight(.regular)
                    Text("Category: \(restaurant.category)")
                        .font(.subheadline)
                        .fontWeight(.regular)
                }
                .padding(.leading, 10) // Agregar un espacio entre la imagen y el texto
            }
            
            Text("Menu")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            ForEach(menuItems, id: \.id) { menuItem in
                HStack {
                    Text(menuItem.name)
                    Spacer()
                    Text("$\(menuItem.price, specifier: "%.2f")")
                        .fontWeight(.semibold)
                    Button(action: {
                                            cart.addItem(menuItem)
                                        }) {
                                            Text("Add to Cart")
                                                .padding(5)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            
            if Reachability.isConnectedToNetwork() {
                fetchMenuItems()
            } else {
                // Mostrar el mensaje de falta de conectividad
                self.showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("No Internet Connection"), message: Text("Please check your internet connection and try again."), dismissButton: .default(Text("OK")))
                }
    }

    func fetchMenuItems() {
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()
        
        for menuReference in restaurant.menu {
            dispatchGroup.enter()
            db.document("producto/\(menuReference)").getDocument { documentSnapshot, error in
                defer {
                    dispatchGroup.leave()
                }
                if let error = error {
                    print("Error fetching menu item: \(error)")
                    return
                }
                if let document = documentSnapshot, document.exists {
                    if let data = document.data(),
                       let name = data["nombre"] as? String,
                       let price = data["precio"] as? Double {
                        let menuItem = MenuItem(id: document.documentID, name: name, price: price)
                        menuItems.append(menuItem)
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            // Aquí puedes realizar cualquier acción después de que se hayan cargado todos los elementos del menú
        }
    }
}

struct MenuItem {
    let id: String
    let name: String
    let price: Double
}
