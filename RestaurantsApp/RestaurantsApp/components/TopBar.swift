//
//  TopBar.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
//

import Foundation
import SwiftUI

// Colors

struct HeaderView: View {
    let title: String
    let profileButtonAction: () -> Void
    let basketButtonAction: () ->Void

    var body: some View {
        ZStack{
            
            HStack (alignment: .center, spacing: 10) {
                
                Button(action: basketButtonAction) {
                    Image(systemName: "cart")
                        .font(.title)
                }
                .padding(.all)
                
                
                
                Spacer()
                
                Button(action: profileButtonAction) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                }
                
                
                Button(action: profileButtonAction) {
                    Image(systemName: "person.circle")
                        .font(.title)
                        .padding(.trailing)
                }
            }
            
            .background(backroundColor)
            .foregroundColor(.white)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}
