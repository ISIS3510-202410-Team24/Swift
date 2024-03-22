//
//  promotionsView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct promotionsView: View {
    @State private var searchText: String = ""
    let firestoreManager = FirestoreManager.shared
    @State private var coupons: [Coupon] = []
    

    var body: some View {
        VStack {
            
            Bar(text: $searchText)
            
                .background(Color(red: 0.4, green: 0.7, blue: 0.7))
            ScrollView {
                VStack {
                  
                    ForEach(coupons, id: \.id) { coupon in
                        CouponView(coupon: coupon)}

                }
            }
        }
        .onAppear {
            fetchCouponsFromFirestore()
        }
    }

    
    
    //FUNCION FETCH
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
                        
                        /*
                        print("Datos obtenidos de Firestore:", queryDocumentSnapshot.data())
                        */
                        
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




//ESTRUCTURA DEL VIEW
struct CouponView: View {
    let coupon: Coupon

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            VStack{
                //Primer Hstack del cupon
                
                Text(coupon.restaurante)
                    .font(Font.custom("Roboto", size: 20))
                    .kerning(0.5)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.28))
                    .frame(width: 100, height: 30, alignment: .topLeading)
                
                HStack{
                    // M3/body/large
                    
                    
                    // M3/body/small
                    
                    //Botón morado
                    HStack(alignment: .center, spacing: 10) {
                        
                        Text("View Menu")
                            .font(Font.custom("Roboto", size: 10))
                            .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.28))
                            .multilineTextAlignment(.center) // Centra el texto horizontalmente
                            .frame(width: 70, height: 22) // Ajusta el tamaño del marco según sea necesario
                        

                    }
                    .padding(.horizontal, 3)
                    .padding(.vertical, 4)
                    .frame(width: 87, height: 22, alignment: .center)
                    .background(Constants.Alerts)
                    .cornerRadius(30)
                    
                }
                
                HStack{
                    
                    // M3/body/small
                    Text(coupon.descripcion)
                        .font(Font.custom("Roboto", size: 12))
                        .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.28))
                        .frame(width: 161, height: 12)
                }
                
                Text(coupon.promocion)
                    .font(Font.custom("Roboto", size:15))
                    .kerning(0.5)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.28))
                    .frame(width: 100, height: 60, alignment: .topLeading)
                
                
            }
            
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 95, height: 94)
                    .background(
                        Image("cupon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 95, height: 94)
                            .clipped()
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0)
                            .stroke(.black, lineWidth: 1)
                    )
                
                Image("mas")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .offset(x: 40, y: -40) // Ajusta la posición para que esté en la esquina derecha
                    .onTapGesture {
                        // Aquí se coloca la acción para que se realice cuando se toque la imagen "mas"
                    }
            }
            
            
        }
        .padding(.leading, 16)
        .padding(.trailing, 40)
        .padding(.vertical, 10)
        .frame(width: 300, height: 183, alignment: .leading)
        .cornerRadius(10)
        .background(Color(red: 0.51, green: 0.77, blue: 0.75))
        .shadow(color: .black.opacity(0.16), radius: 2, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 0.41, green: 0.41, blue: 0.41), lineWidth: 2)
        )
    }
}



//ESTRUCTURA GLOBAL DEL PROMOTION
struct PromotionPreView: PreviewProvider {
    static var previews: some View {
        promotionsView()
    }
}

struct Constants {
    static let Alerts: Color = Color(red: 0.78, green: 0.59, blue: 0.75)
}


//ESTRUCTURA DEL CUPON
struct Coupon: Identifiable, Codable {
    @DocumentID var id: String?
    var promocion: String
    var platoId: Int
    var restaurante: String
    var descripcion: String
}

struct Bar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "arrow.left")
                .foregroundColor(.blue)
                .font(.title)
                .onTapGesture {
                    // Add action when arrow is tapped
                    print("Arrow tapped!")
                }

            Text("Offers")
                .font(Font.custom("Roboto", size: 30))
                .foregroundColor(.black)
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
        .frame(width: 500, height: 60)
    }
}
    
