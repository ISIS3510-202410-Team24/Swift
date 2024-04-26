//
//  basketView.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán 2 on 16/04/24.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct basketView: View {
    @Binding var isShowing: Bool
    let firestoreManager = FirestoreManager.shared
    @ObservedObject var viewModel = PromotionViewModel()
    var body: some View {
        if isShowing{
            
            Rectangle()
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {isShowing.toggle()}
            
            Spacer().frame(height: 20)
            HStack{
                Spacer()
                VStack(alignment: .leading,spacing: 32)  {
                    

                    // M3/title/large
                    
                    
                    //ScrollView {
                        
                        
                        
                        //VStack(alignment: .leading,spacing: 32) {
                            
                            ScrollView{
                            
                                Spacer().frame(height: 20)
                                Text("Your basket")
                                            .font(Font.custom("Roboto", size: 22))
                                            .foregroundColor(.black)
                                        
                                        Spacer().frame(height: 3)
                            
                            //ForEach(viewModel.coupons.filter { $0.enBasket }, id: \.id) { coupon in
                              //  CouponView(coupon: coupon)
                            // solo los cupones que esten en basket se mostrarán
                                Spacer().frame(height: 20)

                            
                            ForEach($viewModel.coupons, id: \.id) { $coupon in
                                
                                    
                                CouponView(coupon: coupon)
                                Spacer().frame(height: 30)
                                
                            }
                                
                                
                                
                                //Botón Pagar
                                HStack(alignment: .center, spacing: 10) {
                                    // M3/title/small
                                    Text("Go to pay")
                                      .font(
                                        Font.custom("Roboto", size: 14)
                                          .weight(.medium)
                                      )
                                      .kerning(0.1)
                                      .foregroundColor(.black)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .frame(width: 180, height: 42, alignment: .center)
                                .background(Constants.Alerts)
                                .cornerRadius(30)
                                .overlay(
                                  RoundedRectangle(cornerRadius: 30)
                                    .inset(by: 0.5)
                                    .stroke(.black, lineWidth: 1)
                                )
                                

                            
                        }.frame(width: 240, height: 700)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                           
                        
                        
                    }
                    
                   
                    
                }.onAppear {
                    viewModel.fetchCouponsFromFirestore()
                }
                
                
                
            }
            
        }
    }
        
//}

#Preview {
    basketView(isShowing: .constant(true))
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
        .frame(width: 200, height: 150, alignment: .leading) // Ajusta el ancho del marco
        .shadow(color: .black.opacity(0.16), radius: 2, x: 0, y: 4)
        
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


