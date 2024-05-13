//
//  ProfileViewModel.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán 2 on 23/04/24.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

// Función para obtener la imagen del usuario

class ProfileViewModel:ObservableObject {
    @Published var documents: [DocumentSnapshot] = []
    @Published var profileName: String = ""
    @Published var profileImage: Image?
    


    func saveProfileImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            // Manejar el caso en el que no se pueda convertir la imagen a datos JPEG
            return
        }
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // Manejar el caso en el que el usuario actual no esté autenticado
            return
        }
        
        // Ruta completa del archivo en Firebase Storage
        let filename = "\(currentUserID).jpg"
        
        // Referencia al archivo existente en Firebase Storage
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
        // Eliminar el archivo existente (si lo hay)
        storageRef.delete { error in
            if let error = error {
                // Manejar el caso en el que ocurra un error al eliminar el archivo existente
                print("Error al eliminar el archivo existente:", error.localizedDescription)
            }
            
            // Subir la nueva imagen a Firebase Storage
            storageRef.putData(data, metadata: nil) { metadata, error in
                guard let _ = metadata else {
                    // Manejar el caso en el que ocurra un error al subir la imagen a Firebase Storage
                    print("Error al subir la imagen a Firebase Storage:", error?.localizedDescription ?? "")
                    return
                }
                
                if let error = error {
                    // Manejar el caso en el que ocurra un error al subir la imagen
                    print("Error al subir la imagen:", error.localizedDescription)
                    return
                }
                
                // Imagen del perfil guardada con éxito en Firebase Storage
            }
        }
    }


    
    
    
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

    
    func getProfileImage(completion: @escaping (UIImage?) -> Void) {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                // Manejar el caso en que el usuario actual no esté autenticado
                completion(nil)
                return
            }

            let storageRef = Storage.storage().reference().child("profile_images")
            let userImageRef = storageRef.child("\(currentUserID).jpg")

            userImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    // Manejar el caso en que ocurra un error al obtener la imagen
                    print("Error al obtener la imagen del perfil:", error.localizedDescription)
                    completion(nil)
                } else {
                    if let imageData = data, let profileImage = UIImage(data: imageData) {
                        // Devolver la imagen del perfil
                        completion(profileImage)
                    } else {
                        // No se pudo convertir los datos en una imagen
                        completion(nil)
                    }
                }
            }
        }
    
    
    
    }

    
