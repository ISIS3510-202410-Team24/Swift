//
//  SideProfileView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 18/03/24.
// edited by Luis Felipe Dussán

import SwiftUI

struct SideProfileView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    @Binding var isShowing: Bool
    @State private var showingPreferences = false
    @State private var selectedImage: UIImage? // Estado para almacenar la imagen seleccionada
    @State private var isShowingImagePicker = false // Estado para controlar la presentación del selector de imágenes
    @State private var profileImage: Image?
    @State private var isLoadingImage = true
       
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
                        if isLoadingImage {
                            // Si se está cargando la imagen, muestra un indicador de carga
                            ProgressView("Cargando imagen...")
                                .onAppear {
                                    // Cuando la vista aparece, solicita la imagen del perfil
                                    profileViewModel.getProfileImage { loadedImage in
                                        // Una vez que la imagen se ha cargado, actualiza isLoadingImage y asigna la imagen al profileImage
                                        isLoadingImage = false
                                        if let loadedImage = loadedImage {
                                            profileImage = Image(uiImage: loadedImage) // Convierte la UIImage a Image
                                        }
                                    }
                                }
                        } else {
                            // Si la imagen se ha cargado, la muestra
                            
                                profileImage?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 230, height: 200)
                                    .clipShape(Circle())
                                    .padding(.bottom, 20)
                                    .onTapGesture {
                                        // Acción al tocar la imagen
                                    }
                            
                        }


                                
                        
                        
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
                                .onAppear {
                                    profileViewModel.getNameUser { name in
                                        if let name = name {
                                            profileViewModel.profileName = name
                                        }
                                    }
                                }
                            // Correo electrónico del perfil obtenido desde loginViewModel
                            if let savedCredentials = loginViewModel.getSavedCredentials() {
                                let email = savedCredentials.email
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 260, height: 50)
                                    .overlay(
                                        Text("\(email)")
                                            .font(.subheadline) // Aquí cambia a .subheadline
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                    )
                                
                            } else {
                                Text("No se ha guardado ningún correo electrónico")
                                    .foregroundColor(.red)
                            }
                            
                            // Botón para las preferencias
                            Button(action: {
                                showingPreferences.toggle()
                            }) {
                                Text("Preferencias")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 10)
                                    .background(Constants.Alerts)
                                    .cornerRadius(8)
                            }.sheet(isPresented: $showingPreferences) {
                                PreferencesView()
                            }
                            
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                Text("Cambiar Imagen")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 10)
                                    .background(Constants.Alerts)
                                    .cornerRadius(8)
                            }
                            
                            if selectedImage != nil{
                                
                                Text("Se cargó la imagen, guarda los cambios")
                                    .padding()
                                    .foregroundColor(.white)
                                
                                // Botón para guardar los datos y cerrar la vista
                                Button(action: {
                                    if let image = selectedImage {
                                        profileViewModel.saveProfileImage(image: image)
                                        profileImage = Image(uiImage: image)
                                        selectedImage = nil // ¿Podría ser este el origen del error?
                                    }
                                }) {
                                    Text("Guardar")
                                        .fontWeight(.medium)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Constants.pinkColor)
                                        .cornerRadius(8)
                                }


                                
                            }
                        }
                        
                        // Más detalles del perfil, si es necesario
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(Color(red: 0.51, green: 0.77, blue: 0.75))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(selectedImage: $selectedImage, isPresented: $isShowingImagePicker)
                    }
                }
                
                ScrollView {
                    VStack {
                        // Contenido adicional del perfil, si es necesario
                    }
                }
            }
        }
    }
    
    struct Constants {
        static let Alerts: Color = Color(red: 0.78, green: 0.59, blue: 0.75)
        static let pinkColor = Color.pink // Agrega este color para usarlo en la vista
    }
}



struct PreferencesView: View {
    @State private var selectedOptions: Set<String> = []

    var body: some View {
        VStack {
            Text("Selecciona tus preferencias")
                .font(.headline)
                .padding()

            HStack {
                Button(action: {
                    if selectedOptions.contains("Vegetariana") {
                        selectedOptions.remove("Vegetariana")
                    } else {
                        selectedOptions.insert("Vegetariana")
                    }
                }) {
                    Text("Vegetariana")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Vegetariana") ? .white : .black)
                }
                .background(selectedOptions.contains("Vegetariana") ? Color.green : Color.gray)
                .cornerRadius(8)

                Button(action: {
                    if selectedOptions.contains("Comida de mar") {
                        selectedOptions.remove("Comida de mar")
                    } else {
                        selectedOptions.insert("Comida de mar")
                    }
                }) {
                    Text("Comida de mar")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Comida de mar") ? .white : .black)
                }
                .background(selectedOptions.contains("Comida de mar") ? Color.green : Color.gray)
                .cornerRadius(8)
            }

            HStack {
                Button(action: {
                    if selectedOptions.contains("Pasta") {
                        selectedOptions.remove("Pasta")
                    } else {
                        selectedOptions.insert("Pasta")
                    }
                }) {
                    Text("Pasta")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Pasta") ? .white : .black)
                }
                .background(selectedOptions.contains("Pasta") ? Color.green : Color.gray)
                .cornerRadius(8)

                Button(action: {
                    if selectedOptions.contains("Saludable") {
                        selectedOptions.remove("Saludable")
                    } else {
                        selectedOptions.insert("Saludable")
                    }
                }) {
                    Text("Saludable")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Saludable") ? .white : .black)
                }
                .background(selectedOptions.contains("Saludable") ? Color.green : Color.gray)
                .cornerRadius(8)
            }

            Button(action: {
                // Aquí puedes guardar las opciones seleccionadas
            }) {
                Text("Guardar")
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.white)
            }
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .frame(maxHeight: .infinity) // Expandir verticalmente
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}


