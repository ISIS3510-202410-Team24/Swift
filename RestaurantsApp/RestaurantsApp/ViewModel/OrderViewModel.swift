import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import FirebaseStorage


class OrderViewModel: ObservableObject {
    @Published var documents: [DocumentSnapshot] = []
    
    func fetchData(completion: @escaping () -> Void) {
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
                            completion() // Llamo al cierre de finalización
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
    
    func saveRating(rating: Int, comment: String, image: UIImage?, completion: @escaping () -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // No se pudo obtener el ID del usuario actual, no se puede guardar la calificación
            return
        }
        
        let db = Firestore.firestore()
        
        var data: [String: Any] = [
            "rating": rating,
            "comment": comment,
            "uId": currentUserID
        ]
        
        if let image = image {
            // Convertir la imagen en un objeto de tipo Data
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                // Subir la imagen a Firebase Storage y obtener su URL
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
                
                imageRef.putData(imageData, metadata: nil) { metadata, error in
                    guard let _ = metadata else {
                        // Error al subir la imagen
                        print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    // Imagen subida con éxito, obtenemos su URL
                    imageRef.downloadURL { url, error in
                        guard let downloadURL = url else {
                            // Error al obtener la URL de descarga de la imagen
                            print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }
                        
                        // URL de descarga de la imagen obtenida con éxito, la guardamos en la base de datos
                        data["imageUrl"] = downloadURL.absoluteString
                        
                        // Guardar los datos en Firestore
                        self.addOrderToFirestore(data: data, completion: completion)
                    }
                }
            }
        } else {
            // No hay imagen para subir, solo guardamos los datos en Firestore
            addOrderToFirestore(data: data, completion: completion)
        }
    }
    
    private func addOrderToFirestore(data: [String: Any], completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("ordenes").addDocument(data: data) { error in
            if let error = error {
                // Error al guardar los datos en Firestore
                print("Error adding document: \(error)")
            } else {
                // Datos guardados con éxito en Firestore
                print("Document added successfully")
                completion() // Llamo al cierre de finalización
            }
        }
    }



}
