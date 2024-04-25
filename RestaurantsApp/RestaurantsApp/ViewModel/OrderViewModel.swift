import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


class OrderViewModel: ObservableObject {
    @Published var documents: [DocumentSnapshot] = []
    
    func fetchData() {
        let db = Firestore.firestore()
        
        // Obtener el ID del usuario actual
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // No se pudo obtener el ID del usuario actual, no se puede proceder con la obtención de datos
            return
        }
        
        // Ejecuto la obtención de datos en un hilo de fondo
        DispatchQueue.global(qos: .background).async {
            db.collection("ordenes")
                .whereField("uId", isEqualTo: currentUserID) // Filtrar por el ID del usuario actual
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error getting documents: \(error)")
                        return
                    } else {
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        
                        // Actualizo los documentos en el hilo principal
                        DispatchQueue.main.async {
                            self.documents = documents
                        }
                    }
                }
        }
    }

    
    func deleteOrder(_ document: DocumentSnapshot) {
        let db = Firestore.firestore()
        
        db.collection("ordenes").document(document.documentID).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                // Eliminación exitosa
                // Aquí podrías realizar alguna actualización adicional si es necesario
                print("Document successfully deleted")
                
                // Remueve el documento eliminado de la lista local
                DispatchQueue.main.async {
                    if let index = self.documents.firstIndex(where: { $0.documentID == document.documentID }) {
                        self.documents.remove(at: index)
                    }
                }
            }
        }
    }

}
