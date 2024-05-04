//
//  SideProfileHeaderView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 18/03/24.
//

import SwiftUI

struct SideProfileHeaderView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @Binding var isShowing: Bool
    @State var profileName: String // Nombre del perfil
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
                            
                            
                            // Nombre del perfil
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 250, height: 50)
                                .overlay(
                                    Text(profileName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                )
                                .onAppear {
                                    // Llama a la función fetchData para obtener el nombre del usuario
                                    profileViewModel.getNameUser { (nombre) in
                                        if let nombre = nombre {
                                            // Asigna el nombre del usuario al estado profileName
                                            profileName = nombre
                                        } else {
                                            // Si no se puede obtener el nombre, muestra un mensaje de error o realiza otra acción apropiada
                                            print("No se pudo obtener el nombre del usuario.")
                                        }
                                    }
                                }
                            
                            // Correo electrónico del perfil
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
    
    
    
    /*
     #Preview {
     SideProfileHeaderView(isShowing: .constant(true), profileName: "John Doe", profileImage: Image(systemName: "person.circle"), profileMail: "john@gmail.com")
     }
     */
}
