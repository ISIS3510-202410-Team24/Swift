//
//  RestaurantCardView.swift
//  RestaurantsApp
//
//  Created by Juan Esteban Rodriguez Ospino on 16/03/24.
//

import SwiftUI
import FirebaseFirestore

// Colors
let backroundColor = Color(UIColor(named: "Background")!)
let blueColor = Color(UIColor(named: "Blue")!)
let pinkColor = Color(UIColor(named: "Pink")!)

struct RestaurantCardView: View {
    var document: DocumentSnapshot // El documento obtenido de Firestore
    var body: some View {
        
            // Stack horizontal de toda la tarjeta
            HStack(alignment: .center) {
              // Space Between
                
                //Stack parte Verde
                HStack(alignment: .center, spacing: 10) {
                    // M3/body/large
                    VStack {
                        Text(document["restaurante"] as? String ?? "Nombre del restaurante")
                            .font(Font.custom("Roboto", size: 16))
                            .kerning(0.5)
                            .foregroundColor(.black)
                        Text(document["direccion"] as? String ?? "Nombre del restaurante")
                            .font(Font.custom("Roboto", size: 16))
                            .kerning(0.5)
                            .foregroundColor(.black)
                        // M3/body/small
                        Text("\(document["valor"] as? Int ?? 0) COP")

                          .font(Font.custom("Roboto", size: 12))
                          .multilineTextAlignment(.center)
                          .foregroundColor(blueColor)
                        
                        HStack(alignment: .center, spacing: 12) {
                            // M3/label/small
                            Text("detail")
                              .font(
                                Font.custom("Roboto", size: 11)
                                  .weight(.medium)
                              )
                              .kerning(0.5)
                              .multilineTextAlignment(.center)
                              .foregroundColor(.black)
                              .frame(width: 38, height: 14, alignment: .center)
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(width: 55, height: 17, alignment: .center)
                        .background(pinkColor)
                        .cornerRadius(32)
                        .overlay(
                          RoundedRectangle(cornerRadius: 32)
                            .inset(by: 1)
                            .stroke(.black, lineWidth: 2)
                        )
                        
                    }
                        
                    }
                    
                    
                .padding(.leading, 12)
                .padding(.trailing, 48)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, minHeight: 82, maxHeight: 82, alignment: .leading)
                .background(backroundColor)
              Spacer()
              // Alternative Views and Spacers
                
                // Stack parte Imagen
                HStack(alignment: .center, spacing: 10) { }
                .padding(.horizontal, 32)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, minHeight: 84, maxHeight: 84, alignment: .center)
                .background(
                    Image("Hamburguesa")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 84)
                    .clipped()
                )
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(backroundColor)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)
            )
    }
}

//#Preview {
//    RestaurantCardView()
//}
