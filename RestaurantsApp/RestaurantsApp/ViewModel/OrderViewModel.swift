import Foundation
import SwiftUI
import FirebaseFirestore

// ViewModel para manejar la lógica de obtención de datos
class OrderViewModel: ObservableObject {
    @Published var documents: [DocumentSnapshot] = []
    
    func fetchData() {
        // Aquí debes implementar la lógica para obtener todos los documentos de la colección "ordenes" de Firestore
        let db = Firestore.firestore()
        db.collection("ordenes").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.documents = documents
            }
        }
    }
}
