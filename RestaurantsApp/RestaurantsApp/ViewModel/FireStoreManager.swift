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
    private let userDefaults = UserDefaults.standard
    
    func agregarDocumento(coleccion: String, datos: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection(coleccion).addDocument(data: datos) { error in
            if let error = error {
                // Guardar datos en caché si hay un error
                self.cacheData(coleccion: coleccion, datos: datos)
            }
            completion(error)
        }
    }
    
    private func cacheData(coleccion: String, datos: [String: Any]) {
        var cachedErrors = userDefaults.array(forKey: "cachedErrors") as? [[String: Any]] ?? []
        var cachedData = datos
        cachedData["coleccion"] = coleccion
        cachedErrors.append(cachedData)
        userDefaults.set(cachedErrors, forKey: "cachedErrors")
    }
    
    func enviarErroresEnCache() {
        guard let cachedErrors = userDefaults.array(forKey: "cachedErrors") as? [[String: Any]] else { return }
        
        for datos in cachedErrors {
            if let coleccion = datos["coleccion"] as? String {
                var datosSinColeccion = datos
                datosSinColeccion.removeValue(forKey: "coleccion")
                db.collection(coleccion).addDocument(data: datosSinColeccion) { error in
                    if error == nil {
                        self.removeCachedData(datos: datos)
                    }
                }
            }
        }
    }
    
    private func removeCachedData(datos: [String: Any]) {
        var cachedErrors = userDefaults.array(forKey: "cachedErrors") as? [[String: Any]] ?? []
        cachedErrors.removeAll { cachedData in
            guard let cachedColeccion = cachedData["coleccion"] as? String,
                  let datosColeccion = datos["coleccion"] as? String else {
                return false
            }
            return cachedColeccion == datosColeccion && NSDictionary(dictionary: cachedData).isEqual(to: datos)
        }
        userDefaults.set(cachedErrors, forKey: "cachedErrors")
    }
}

