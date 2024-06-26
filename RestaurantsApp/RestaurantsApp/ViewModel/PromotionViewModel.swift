//
//  PromotionViewModel.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán 2 on 22/03/24.
//

import Foundation
import FirebaseFirestore


class PromotionViewModel: ObservableObject {
    @Published var coupons: [Coupon] = []

    /*
     Multithread:
    La función getDocuments de la instancia de Firestore hace una llamada asíncrona para obtener los documentos de la colección "cupones" en Firestore. Esta llamada no bloquea el hilo principal de la aplicación, lo que significa que el flujo de ejecución continúa mientras Firestore realiza la operación de obtención en segundo plano.
     
     Una vez que se completa el procesamiento de documentos y se obtienen los cupones, se utiliza DispatchQueue.main.async para devolver la actualización de la interfaz de usuario al hilo principal. Esto es importante porque la interfaz de usuario solo debe actualizarse en el hilo principal. Dentro del bloque async, se asigna fetchedCoupons a self.coupons, lo que actualiza la interfaz de usuario con los datos recuperados. Además, se imprime un mensaje indicando que los cupones han sido recuperados.
    */
    func fetchCouponsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("cupones").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error al obtener los documentos: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No hay documentos")
                return
            }
            let fetchedCoupons = documents.compactMap { queryDocumentSnapshot -> Coupon? in
                if queryDocumentSnapshot.exists {
                    do {
                        let coupon = try queryDocumentSnapshot.data(as: Coupon.self)
                        return coupon
                    } catch {
                        print("Error al decodificar datos de cupón: \(error.localizedDescription)")
                        return nil
                    }
                } else {
                    print("El documento está vacío")
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.coupons = fetchedCoupons
                print("Cupones recuperados:", self.coupons)
            }
        }
    }
    
    // Método para incrementar el contador de redenciones para un cupón específico
    func incrementarRedencionesParaCupon(cuponID: String) {
        let db = Firestore.firestore()
        let cuponesRef = db.collection("cupones").document(cuponID)

        // Atomically increment the redemptions field by 1
        cuponesRef.updateData(["redenciones": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error incrementando redenciones: \(error)")
            } else {
                print("Redención exitosa")
            }
        }
    }
}



//ESTRUCTURA DEL CUPON
struct Coupon: Identifiable, Codable {
    @DocumentID var id: String?
    var promocion: String
    var platoId: Int
    var restaurante: String
    var descripcion: String
    var enBasket: Bool
    var code: String
    var redenciones: Int
}


