//
//  SideProfileView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 18/03/24.
//

import SwiftUI

struct SideProfileView: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack{
            if isShowing{
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {isShowing.toggle()}
                
                HStack{
                    
                    Spacer()
                    VStack(alignment: .leading,spacing: 32){
                        SideProfileHeaderView()
                        
                        Spacer()
                        
                    }
                    .padding()
                    .frame(width: 270,alignment: .leading)
                    .background(.white)
                    
                    
                    
                }
                
                }
            }
        }
    }


#Preview {
    SideProfileView(isShowing: .constant(true))
}
