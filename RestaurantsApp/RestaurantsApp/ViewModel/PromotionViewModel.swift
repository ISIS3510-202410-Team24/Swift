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
}


//ESTRUCTURA DEL CUPON
struct Coupon: Identifiable, Codable {
    @DocumentID var id: String?
    var promocion: String
    var platoId: Int
    var restaurante: String
    var descripcion: String
}
