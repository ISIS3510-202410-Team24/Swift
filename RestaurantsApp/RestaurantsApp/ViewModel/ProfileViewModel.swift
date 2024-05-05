//
//  ProfileViewModel.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán 2 on 23/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// Función para obtener la imagen del usuario

class ProfileViewModel:ObservableObject {
    @Published var documents: [DocumentSnapshot] = []
    @Published var profileName: String = ""
    
    func getNameUser(completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        // Obtener el ID del usuario actual
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // No se pudo obtener el ID del usuario actual, no se puede proceder con la obtención de datos
            completion(nil)
            return
        }
      
        // Realiza la consulta en la colección "usuario" filtrando por el campo "userId"
        db.collection("usuario")
            .document(currentUserID) // Utiliza directamente el ID del usuario como ID del documento
            .getDocument { (document, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    completion(nil)
                } else {
                    // Verifica si se encontró el documento y si contiene el campo "nombre"
                    if let document = document, document.exists {
                        if let profileName = document.data()?["name"] as? String {
                            // Llama al bloque de finalización con el nombre del usuario
                            completion(profileName)
                        } else {
                            // Si no se encuentra el campo "nombre", llama al bloque de finalización con nil
                            print("No se encontró el campo 'nombre' en el documento.")
                            completion(nil)
                        }
                    } else {
                        // Si no se encuentra el documento, llama al bloque de finalización con nil
                        print("No se encontró un documento con el ID de usuario proporcionado.")
                        completion(nil)
                    }
                }
            }
    }

    
    
    
    }

    
    
