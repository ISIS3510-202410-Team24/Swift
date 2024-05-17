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
    @State private var userPreferences: [String] = []
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
                        
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            Text("Cambiar Imagen")
                                .font(.caption) // Cambia el tamaño de la fuente
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 15) // Reducir el padding horizontal
                                .padding(.vertical, 6) // Reducir el padding vertical
                                .background(Constants.Alerts)
                                .cornerRadius(8)
                        }
                        
                        if selectedImage != nil{
                            
                            Text("guarda los cambios")
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
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                            
                            
                        }
                        
                        
                        
                        VStack(alignment: .center, spacing: 10) {
                            
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
                                    }
                            }
                            
                            
                            
                            
                            /*
                            if !userPreferences.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Tus Preferencias: ")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    ForEach(userPreferences, id: \.self) { preference in
                                        Text(preference)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .padding(.top, 20)
                            }
                            */
                            
                            // Organiza las imágenes en filas de tres
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(0..<userPreferences.count, id: \.self) { index in
                                    Image(userPreferences[index]) // Suponiendo que userPreferences contiene los nombres de las imágenes de comida
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.vertical, 10) // Agrega un espacio vertical después de las imágenes
                            .padding(.horizontal, 10) // Ajusta el espacio horizontal entre las imágenes

                            
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
                .onAppear {
                    // Obtener las preferencias del usuario al cargar la vista
                    profileViewModel.getPreferences { preferences in
                        if let preferences = preferences {
                            userPreferences = preferences
                        }
                    }
                }
                .onReceive(profileViewModel.$savedPreferences) { savedPreferences in
                    self.userPreferences = savedPreferences
                }
                .onAppear {
                    // Check Internet connection
                    isInternetAvailable = Reachability.isConnectedToNetwork()
                    if !isInternetAvailable {
                        // Show alert if no Internet
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
    
    struct PreferencesView: View {
        @State private var selectedOptions: Set<String> = []
        @ObservedObject var profileViewModel = ProfileViewModel()
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
                    .background(selectedOptions.contains("Vegetariana") ? Constants.Alerts: Color.gray)
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
                    .background(selectedOptions.contains("Comida de mar") ?  Constants.Alerts : Color.gray)
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
                    .background(selectedOptions.contains("Hamburguesas") ?  Constants.Alerts: Color.gray)
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
                    .background(selectedOptions.contains("Parrilla") ? Constants.Alerts: Color.gray)
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
}
