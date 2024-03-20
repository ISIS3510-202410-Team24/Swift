import Foundation
import Firebase
import FirebaseFirestore

class FirebaseFunctions {
    static let shared = FirebaseFunctions() // Singleton para acceder a las funciones
    
    func agregarDocumento(texto: String) {
        let db = Firestore.firestore()
        
        db.collection("ejemplo").addDocument(data: [
            "texto": texto
        ]) { error in
            if let error = error {
                print("Error al agregar documento: \(error)")
            } else {
                print("Documento agregado correctamente")
            }
        }
    }
    
    func leerDocumento(documentoID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("ejemplo").document(documentoID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let texto = document.data()?["texto"] as? String {
                    completion(texto)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func actualizarDocumento(documentoID: String, nuevoTexto: String) {
        let db = Firestore.firestore()
        
        db.collection("ejemplo").document(documentoID).updateData([
            "texto": nuevoTexto
        ]) { error in
            if let error = error {
                print("Error al actualizar documento: \(error)")
            } else {
                print("Documento actualizado correctamente")
            }
        }
    }
}
