//
//  FireStoreManager.swift
//  RestaurantsApp
//
//  Created by Estudiantes on 20/03/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    func agregarDocumento(coleccion: String, datos: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection(coleccion).addDocument(data: datos, completion: completion)
    }
    
    func leerDocumento(coleccion: String, documentoID: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        db.collection(coleccion).document(documentoID).getDocument(completion: completion)
    }
    
    func actualizarDocumento(coleccion: String, documentoID: String, datos: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection(coleccion).document(documentoID).updateData(datos, completion: completion)
    }
}
