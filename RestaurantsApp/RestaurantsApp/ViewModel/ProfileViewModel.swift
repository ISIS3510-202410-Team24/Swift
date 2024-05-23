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
import UIKit


// Función para obtener la imagen del usuario

class ProfileViewModel:ObservableObject {
    @Published var documents: [DocumentSnapshot] = []
    @Published var profileName: String = ""
    @Published var profileImage: Image?
    @Published var savedPreferences: [String] = [] // Agregar una propiedad para almacenar las preferencias
        
   

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


    
    
    
    func getProfileName() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // Manejar el caso en que el usuario actual no esté autenticado
            return
        }
        
        // Verificar si el nombre de usuario está en la caché local
        if let cachedName = UserDefaults.standard.string(forKey: "profileName_\(currentUserID)") {
            // Actualizar la propiedad profileName con el nombre de usuario de la caché
            self.profileName = cachedName
            return
        }
        
        // Referencia al documento de perfil del usuario en Firestore
        let profileRef = Firestore.firestore().collection("usuario").document(currentUserID)
        
        // Obtener el nombre de usuario de Firestore
        profileRef.getDocument { document, error in
            if let error = error {
                // Manejar el caso en que ocurra un error al obtener el nombre de usuario de Firestore
                print("Error al obtener el nombre de usuario de Firestore:", error.localizedDescription)
            } else {
                if let document = document, document.exists {
                    if let name = document.data()?["name"] as? String {
                        // Actualizar la propiedad profileName con el nombre de usuario obtenido
                        self.profileName = name
                        
                        // Guardar el nombre de usuario en la caché local (UserDefaults)
                        UserDefaults.standard.set(name, forKey: "profileName_\(currentUserID)")
                    }
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

        // Verificar si la imagen está en la caché local
        if let cachedImageData = UserDefaults.standard.data(forKey: "profileImage_\(currentUserID)"),
           let profileImage = UIImage(data: cachedImageData) {
            // Devolver la imagen desde la caché local
            completion(profileImage)
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
                    // Guardar la imagen en la caché local
                    UserDefaults.standard.set(imageData, forKey: "profileImage_\(currentUserID)")
                    // Devolver la imagen del perfil
                    completion(profileImage)
                } else {
                    // No se pudo convertir los datos en una imagen
                    completion(nil)
                }
            }
        }
    }

    //Acá se guardan en cache
    class PreferencesCache {
        static var userPreferences: [String] = []
    }
    
    
    func savePreferences(preferences: [String]) {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                // Manejar el caso en el que el usuario actual no esté autenticado
                return
            }
            
            // Referencia al documento de preferencias del usuario
            let preferencesRef = Firestore.firestore().collection("usuario").document(currentUserID).collection("preferences").document("user_preferences")
            
            // Guardar las preferencias en Firestore
            preferencesRef.setData(["preferences": preferences]) { error in
                if let error = error {
                    // Manejar el caso en el que ocurra un error al guardar las preferencias
                    print("Error al guardar las preferencias:", error.localizedDescription)
                } else {
                    print("Preferencias guardadas con éxito")
                }
            }
            PreferencesCache.userPreferences = preferences
            self.savedPreferences = preferences
        }
    
    func getPreferences(completion: @escaping ([String]?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // Manejar el caso en que el usuario actual no esté autenticado
            completion(nil)
            return
        }
        
        // Verificar si las preferencias están en la caché local
        if !PreferencesCache.userPreferences.isEmpty {
            // Devolver las preferencias desde la caché local
            self.savedPreferences = PreferencesCache.userPreferences
            completion(PreferencesCache.userPreferences)
            return
        }
        
        // Referencia al documento de preferencias del usuario
        let preferencesRef = Firestore.firestore().collection("usuario").document(currentUserID).collection("preferences").document("user_preferences")
        
        // Obtener las preferencias guardadas en Firestore
        preferencesRef.getDocument { snapshot, error in
            if let error = error {
                // Manejar el caso en que ocurra un error al obtener las preferencias
                print("Error al obtener las preferencias:", error.localizedDescription)
                completion(nil)
            } else {
                if let preferencesData = snapshot?.data(),
                   let preferences = preferencesData["preferences"] as? [String] {
                    // Guardar las preferencias en la caché local
                    PreferencesCache.userPreferences = preferences
                    self.savedPreferences = preferences
                    // Devolver las preferencias obtenidas
                    completion(preferences)
                } else {
                    // Manejar el caso en el que no se encuentren preferencias o el formato sea incorrecto
                    completion(nil)
                }
            }
        }
    }


    
    func saveProfileName(name: String) {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                // Manejar el caso en que el usuario actual no esté autenticado
                return
            }
            
            // Referencia al documento de perfil del usuario en Firestore
            let profileRef = Firestore.firestore().collection("usuario").document(currentUserID)
            
            // Guardar el nombre de usuario en Firestore
            profileRef.setData(["name": name], merge: true) { error in
                if let error = error {
                    // Manejar el caso en que ocurra un error al guardar el nombre de usuario en Firestore
                    print("Error al guardar el nombre de usuario:", error.localizedDescription)
                } else {
                    print("Nombre de usuario guardado con éxito en Firestore")
                }
            }
            
            // Guardar el nombre de usuario en la caché local (UserDefaults)
            UserDefaults.standard.set(name, forKey: "profileName_\(currentUserID)")
            
            // Actualizar la propiedad profileName
            self.profileName = name
        }

       

    
    
    }

    
