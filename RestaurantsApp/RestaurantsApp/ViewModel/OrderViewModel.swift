import Foundation
import SwiftUI
import FirebaseFirestore

class OrderViewModel: ObservableObject {
    @Published var documents: [DocumentSnapshot] = []
    
    func fetchData() {
        // Aquí debes implementar la lógica para obtener todos los documentos de la colección "ordenes" de Firestore
        let db = Firestore.firestore()
        
        // Ejecutar la obtención de datos en un hilo de fondo
        DispatchQueue.global(qos: .background).async {
            db.collection("ordenes").getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    // Actualizar los documentos en el hilo principal
                    DispatchQueue.main.async {
                        self.documents = documents
                    }
                }
            }
        }
    }
}
