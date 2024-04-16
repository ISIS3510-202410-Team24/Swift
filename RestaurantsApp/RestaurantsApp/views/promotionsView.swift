//
//  promotionsView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
// Edited by Luis Felipe Dussán on 19/03/24

import SwiftUI
import FirebaseFirestore
import Firebase

struct promotionsView: View {
    @State private var searchText: String = ""
    let firestoreManager = FirestoreManager.shared
    @ObservedObject var viewModel = PromotionViewModel()
    
    
    var body: some View {
        VStack {
            
            //Bar(text: $searchText)
            
            //    .background(Color(pinkColor))
            ScrollView {
                VStack {
                    
                    ForEach($viewModel.coupons, id: \.id) { $coupon in
                        CouponView(coupon: coupon)
                    }
                    
                }
            }
        }
        .onAppear {
            viewModel.fetchCouponsFromFirestore()
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
                            
                            Text("Detail")
                                .font(Font.custom("Roboto", size: 10))
                                .foregroundColor(Color.black)
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
            .padding(.trailing, 16) // Reduce el relleno derecho para equilibrar el espacio
            .padding(.vertical, 10)
            .background(Color(red: 0.51, green: 0.77, blue: 0.75))
            .cornerRadius(20) // Redondear las esquinas después de aplicar el fondo y antes del tamaño
            .frame(width: 290 - 16 + 40, height: 183, alignment: .leading) // Ajusta el ancho del marco
            .shadow(color: .black.opacity(0.16), radius: 2, x: 0, y: 4)
            
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
    
 
    struct Bar: View {
        @Binding var text: String
        
        var body: some View {
            HStack {
                
                /*
                 Image(systemName: "arrow.left")
                 .foregroundColor(.blue)
                 .font(.title)
                 .onTapGesture {
                 // Add action when arrow is tapped
                 print("Arrow tapped!")
                 }
                 */
                Text("Offers")
                    .font(Font.custom("Roboto", size: 30))
                    .foregroundColor(.black)
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .frame(width: 500, height: 60)
        }
    }
    
}
