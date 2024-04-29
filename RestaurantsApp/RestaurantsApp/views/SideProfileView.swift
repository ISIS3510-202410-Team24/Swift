//
//  SideProfileView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 18/03/24.
//

import SwiftUI

struct SideProfileView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    @Binding var isShowing: Bool
    var profileImage: Image // Imagen del perfil
    
    var body: some View {
        
        
        ZStack {
            if isShowing {
                // Fondo oscuro cuando se muestra el perfil
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                
                HStack {
                    
                    Spacer().frame(height: 20)
                    
                    VStack(alignment: .center, spacing: 16) {
                        
                        // Imagen del perfil
                        profileImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 230, height: 200)
                            .clipShape(Circle())
                            .padding(.bottom, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            // Nombre del perfil obtenido desde profileViewModel
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 250, height: 50)
                                .overlay(
                                    
                                   
                                    Text(profileViewModel.profileName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                )
                              
                            
                            // Correo electrónico del perfil obtenido desde loginViewModel
                            if let savedCredentials = loginViewModel.getSavedCredentials() {
                                let email = savedCredentials.email
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 260, height: 50)
                                    .overlay(
                                        Text("\(email)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                    )
                            } else {
                                Text("No se ha guardado ningún correo electrónico")
                                    .foregroundColor(.red) // Opcional: Si deseas un color específico para este caso
                            }
                            
                            // Poner acá el restaurante del que más pide ordenes
                            
                        }
                        
                        // Más detalles del perfil, si es necesario
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(Color(red: 0.51, green: 0.77, blue: 0.75))
                }
                
                ScrollView {
                    VStack {
                        // Contenido adicional del perfil, si es necesario
                    }
                }
            }
        }
    }
}
