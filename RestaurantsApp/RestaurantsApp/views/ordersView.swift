//
//  ordersView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
//

import SwiftUI

struct ordersView: View {
    var body: some View {
        
        // Stack Principal
        VStack(alignment: .leading, spacing: 10) {
            
            // Stack Para los primeros titulos
            VStack(alignment: .leading, spacing: 8) {
                // M3/title/large
                Text("Current orders")
                  .font(Font.custom("Roboto", size: 22))
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
                // M3/title/small
                Text("Check the state of your orders")
                  .font(
                    Font.custom("Roboto", size: 14)
                      .weight(.medium)
                  )
                  .kerning(0.1)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 0)
            
            // Stack Vertical para las ordenes Actuales
            VStack(alignment: .leading, spacing: 10) {
                RestaurantCardView()
                RestaurantCardView()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, minHeight: 223, maxHeight: 223, alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: 8) {
                // M3/title/large
                Text("History of orders")
                  .font(Font.custom("Roboto", size: 22))
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
                // M3/title/small
                Text("Check your latest orders and restaurants")
                  .font(
                    Font.custom("Roboto", size: 14)
                      .weight(.medium)
                  )
                  .kerning(0.1)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 0)
            
            // Stack vertical para el historial de Pedidos
            VStack(alignment: .leading, spacing: 10) {
                RestaurantCardView()
                RestaurantCardView()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 0)
            .frame(maxWidth: .infinity, minHeight: 223, maxHeight: 223, alignment: .topLeading)
            
        }
        .padding(.horizontal, 0)
        .padding(.top, 24)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
    }
        
}

#Preview {
    ordersView()
}
