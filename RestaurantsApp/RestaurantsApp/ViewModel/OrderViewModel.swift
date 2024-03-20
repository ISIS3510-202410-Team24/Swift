//
//  RestaurantViewModel.swift
//  RestaurantsApp
//
//  Created by Estudiantes on 20/03/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

// ViewModel para manejar la lógica de obtención de datos
class OrderViewModel: ObservableObject {
    @Published var document: DocumentSnapshot?
    
    func fetchData() {
        // Aquí debes implementar la lógica para obtener el documento de Firestore
        // Esto es solo un ejemplo básico
        let db = Firestore.firestore()
        db.collection("ordenes").document("5XuXYpq23vXeMUeCvSP0").getDocument { document, error in
            if let document = document, document.exists {
                self.document = document
            } else {
                print("Document does not exist")
            }
        }
    }
}
