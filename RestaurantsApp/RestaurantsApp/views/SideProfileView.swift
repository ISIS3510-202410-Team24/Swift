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
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var profileImage: Image?
    @State private var isLoadingImage = true
    @State private var showPreferences = false
    @State private var isInternetAvailable = true
    
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
                            ProgressView("Cargando imagen...")
                                .onAppear {
                                    // Cuando la vista aparece, solicita la imagen del perfil
                                    profileViewModel.getProfileImage { loadedImage in
                                        isLoadingImage = false
                                        if let loadedImage = loadedImage {
                                            profileImage = Image(uiImage: loadedImage)
                                        }
                                    }
                                }
                        } else {
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
                        
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            Text("Cambiar Imagen")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 6)
                                .background(Constants.Alerts)
                                .cornerRadius(8)
                        }
                        
                        if selectedImage != nil {
                            Text("guarda los cambios")
                                .padding()
                                .foregroundColor(.white)
                            
                            Button(action: {
                                if let image = selectedImage {
                                    profileViewModel.saveProfileImage(image: image)
                                    profileImage = Image(uiImage: image)
                                    selectedImage = nil
                                }
                            }) {
                                Text("Guardar")
                                    .fontWeight(.medium)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .center, spacing: 10) {
                            // Nombre del perfil
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 250, height: 50)
                                .overlay(
                                    Text(profileViewModel.profileName) // Utiliza el nombre de perfil del ViewModel
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                )
                                .onAppear {
                                    profileViewModel.getProfileName() // Actualiza el nombre de perfil al aparecer la vista
                                }
                            
                            // Correo electrónico del perfil
                            if let savedCredentials = loginViewModel.getSavedCredentials() {
                                let email = savedCredentials.email
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 260, height: 50)
                                    .overlay(
                                        Text("\(email)")
                                            .font(.subheadline)
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
                                showPreferences.toggle()
                            }) {
                                Text("Preferencias")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 10)
                                    .background(Constants.Alerts)
                                    .cornerRadius(8)
                                    .sheet(isPresented: $showPreferences) {
                                        PreferencesView(isShowingPreferences: $showPreferences)
                                            .environmentObject(profileViewModel)
                                    }
                            }
                            
                            // Organiza las imágenes en filas de tres
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(0..<profileViewModel.savedPreferences.count, id: \.self) { index in
                                    Image(profileViewModel.savedPreferences[index]) // Utiliza las preferencias del ViewModel
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                        }
                        
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
                .onAppear {
                    // Comprueba la conexión a Internet al cargar la vista
                    isInternetAvailable = Reachability.isConnectedToNetwork()
                    if !isInternetAvailable {
                        // Muestra una alerta si no hay conexión a Internet
                        showingPreferences = true
                    }
                }
                .alert(isPresented: $showingPreferences) {
                    Alert(
                        title: Text("No hay conexión a Internet"),
                        message: Text("La imagen fue guardada en caché, pero otros cambios adicionales no serán guardados hasta reconectar."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onAppear {
                    // Obtener las preferencias del usuario al cargar la vista
                    profileViewModel.getPreferences { preferences in
                        if let preferences = preferences {
                            profileViewModel.savedPreferences = preferences // Actualiza las preferencias del ViewModel
                        }
                    }
                }
            }
        }
    }
}
    struct Constants {
        static let Alerts: Color = Color(red: 0.78, green: 0.59, blue: 0.75)
    }



struct PreferencesView: View {
    @State private var selectedOptions: Set<String> = []
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Binding var isShowingPreferences: Bool
    
    var body: some View {
        VStack(spacing: 30) { // Aumenta el espacio entre los elementos
            Text("Selecciona tus preferencias")
                .font(.headline)
                .padding()
            
            HStack {
                // Botón para Vegetariana
                Button(action: {
                    toggleOption("Vegetariana")
                }) {
                    Text("Vegetariana")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Vegetariana") ? .white : .black)
                }
                .background(selectedOptions.contains("Vegetariana") ? Constants.Alerts : Color.gray)
                .cornerRadius(8)
                
                // Botón para Comida de mar
                Button(action: {
                    toggleOption("Comida de mar")
                }) {
                    Text("Comida de mar")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Comida de mar") ? .white : .black)
                }
                .background(selectedOptions.contains("Comida de mar") ? Constants.Alerts : Color.gray)
                .cornerRadius(8)
                
                // Agregar más botones para las nuevas preferencias
                // Por ejemplo, para hamburguesas
                Button(action: {
                    toggleOption("Hamburguesas")
                }) {
                    Text("Hamburguesas")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Hamburguesas") ? .white : .black)
                }
                .background(selectedOptions.contains("Hamburguesas") ? Constants.Alerts : Color.gray)
                .cornerRadius(8)
                
                // Botón para Pollo
                Button(action: {
                    toggleOption("Pollo")
                }) {
                    Text("Pollo")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Pollo") ? .white : .black)
                }
                .background(selectedOptions.contains("Pollo") ? Constants.Alerts : Color.gray)
                .cornerRadius(8)
            }
            
            HStack {
                // Botón para Parrilla
                Button(action: {
                    toggleOption("Parrilla")
                }) {
                    Text("Parrilla")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Parrilla") ? .white : .black)
                }
                .background(selectedOptions.contains("Parrilla") ? Constants.Alerts : Color.gray)
                .cornerRadius(8)
                
                // Botón para Mexicana
                Button(action: {
                    toggleOption("Mexicana")
                }) {
                    Text("Mexicana")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Mexicana") ? .white : .black)
                }
                .background(selectedOptions.contains("Mexicana") ? Constants.Alerts : Color.gray)
                .cornerRadius(8)
                
                // Botón para Asiática
                Button(action: {
                    toggleOption("Asiática")
                }) {
                    Text("Asiática")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(selectedOptions.contains("Asiática") ? .white : .black)
                }
                .background(selectedOptions.contains("Asiática") ? Constants.Alerts : Color.gray)
                .cornerRadius(8)
            }
            
            // Botón Guardar y Cancelar
            HStack(spacing: 20) { // Aumenta el espacio entre los botones
                Button(action: {
                    let selectedOptionsArray = Array(selectedOptions)
                    profileViewModel.savePreferences(preferences: selectedOptionsArray)
                    profileViewModel.savedPreferences = selectedOptionsArray
                    isShowingPreferences = false
                }) {
                    Text("Guardar")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                }
                .background(Color.green)
                .cornerRadius(8)
                
                Button(action: {
                    isShowingPreferences = false
                }) {
                    Text("Cancelar")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                }
                .background(Color.red)
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxHeight: .infinity) // Expandir verticalmente
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .onAppear {
            selectedOptions = Set(profileViewModel.savedPreferences)
        }
    }
    
    // Función para alternar la selección de una opción
    private func toggleOption(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}
