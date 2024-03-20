//
//  RestaurantCardView.swift
//  RestaurantsApp
//
//  Created by Juan Esteban Rodriguez Ospino on 16/03/24.
//

import SwiftUI

// Colors
let backroundColor = Color(UIColor(named: "Background")!)
let blueColor = Color(UIColor(named: "Blue")!)



struct RestaurantCardView: View {
    var body: some View {
        
            // Stack horizontal de toda la tarjeta
            HStack(alignment: .center) {
              // Space Between
                
                //Stack parte Verde
                HStack(alignment: .center, spacing: 10) {
                    // M3/body/large
                    VStack {
                        Text("El Corral\n#17 Cra. 9")
                            .font(Font.custom("Roboto", size: 16))
                            .kerning(0.5)
                            .foregroundColor(.black)
                        // M3/body/small
                        Text("12.000 COP")
                          .font(Font.custom("Roboto", size: 12))
                          .multilineTextAlignment(.center)
                          .foregroundColor(blueColor)
                    }
                    
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
                    .background(backroundColor)
                    .cornerRadius(32)
                    .overlay(
                      RoundedRectangle(cornerRadius: 32)
                        .inset(by: 1)
                        .stroke(.black, lineWidth: 2)
                    )
                    
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
                    Image("Burguer")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 164, height: 84)
                    .clipped()
                )
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)
                .onAppear{
                    
                    FirestoreManager.shared.leerDocumento(coleccion: "miColeccion", documentoID: "miDocumentoID") { documentSnapshot, error in
                        if let error = error {
                            print("Error al leer documento: \(error)")
                        } else if let document = documentSnapshot, document.exists {
                            let datos = document.data() ?? [:]
                            print("Datos del documento: \(datos)")
                        } else {
                            print("Documento no encontrado")
                        }
                    }
                }
            )
    }
}

#Preview {
    RestaurantCardView()
}
