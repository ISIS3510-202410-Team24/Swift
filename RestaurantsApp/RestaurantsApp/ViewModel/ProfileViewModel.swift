//
//  ProfileViewModel.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán 2 on 23/04/24.
//

import Foundation
import FirebaseFirestore

// Función para obtener la imagen del usuario
/*
func fetchUserProfile(userId: String) {
    let db = Firestore.firestore()
    let userRef = db.collection("usuarios").document(userId)
    
    userRef.getDocument { document, error in
        if let error = error {
            errorMessage = "Error al obtener el perfil del usuario: \(error.localizedDescription)"
            return
        }
        
        guard let document = document, document.exists else {
            errorMessage = "El usuario no existe"
            return
        }
        
        do {
            let userProfile = try document.data(as: UserProfile.self)
            guard let userProfile = userProfile else {
                errorMessage = "No se pudo decodificar el perfil del usuario"
                return
            }
            self.userProfile = userProfile
        } catch {
            errorMessage = "Error al decodificar el perfil del usuario: \(error.localizedDescription)"
        }
    }
}
*/
