import SwiftUI
import FirebaseFirestore

struct RestaurantView: View {
    var restaurant: Restaurant
    @State private var menuItems: [MenuItem] = [] // Estado para almacenar los elementos del menú

    var body: some View {
        VStack(spacing: 10) {
            
            Text(restaurant.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
                .multilineTextAlignment(.center)
            
            HStack {
                // Mostrar la imagen del restaurante
                AsyncImage(url: restaurant.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    // Placeholder mientras se carga la imagen
                    ProgressView()
                }
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
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            fetchMenuItems()
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
