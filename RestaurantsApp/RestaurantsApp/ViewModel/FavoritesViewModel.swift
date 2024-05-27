//
//  FavoritesViewModel.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán 2 on 22/05/24.
//

import FirebaseFirestore
import Combine

class FavoritesViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    // Publica un array de platos que son favoritos
    @Published var favoriteDishes: [Dish] = []
    
    func fetchFavoriteDishes() {
        // Accede a la colección "dishes" en Firebase
        db.collection("dishes")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                // Filtra los platos con un rating superior a 4
                let filteredDishes = documents.compactMap { document -> Dish? in
                    let dishData = document.data()
                    if let name = dishData["name"] as? String,
                       let rating = dishData["rating"] as? Double,
                       rating > 4 {
                        return Dish(name: name, rating: rating, price: dishData["price"] as? Double ?? 0.0, image: dishData["image"] as? String ?? "")
                    } else {
                        return nil
                    }
                }
                
                // Actualiza los platos favoritos en el ViewModel
                DispatchQueue.main.async {
                    self?.favoriteDishes = filteredDishes
                }
            }
    }
}

struct Dish: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let price: Double
    let image: String
}
