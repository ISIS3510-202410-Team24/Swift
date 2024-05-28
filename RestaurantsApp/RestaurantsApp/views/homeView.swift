//
//  homeView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore

struct HomeView: View {
    @StateObject var viewModel: FavoritesViewModel
    @State private var showReportErrorView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Mensajes de bienvenida
                Text("Satisfy your cravings with just a few taps")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .kerning(0.1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top)
                
                Text("Check out our restaurants")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .kerning(0.15)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.bottom)
                
                // Título de la sección
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .padding(.top)
                    .foregroundColor(Color.black) // Cambiar color de texto
                
                // Lista de platos favoritos
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(viewModel.favoriteDishes) { dish in
                            DishRow(dish: dish)
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(.top)
                }
                
                // Botón para reportar errores
                Button(action: {
                    showReportErrorView = true
                }) {
                    Text("Report an Error")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showReportErrorView) {
                    ReportErrorView()
                }
            }
            .onAppear {
                viewModel.fetchFavoriteDishes()
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .modifier(ShakeDetectorModifier {
                showReportErrorView = true
            })
        }
    }
}

struct DishRow: View {
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading) {
            // Imagen del plato
            WebImage(url: URL(string: dish.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                // Placeholder mientras se carga la imagen
                ProgressView()
            }
            
            // Calificación del plato
            HStack {
                Text(String(format: "%.1f", dish.rating))
                    .foregroundColor(Color.yellow)
                    .font(.headline)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            }
            .padding(.horizontal)
            
            // Nombre del plato
            Text(dish.name)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .foregroundColor(Color.black) // Cambiar color de texto
            
            // Precio del plato
            Text("$\(dish.price, specifier: "%.2f")")
                .foregroundColor(Color.gray)
                .padding(.horizontal)
            
            // Botón para ordenar el plato
            Button(action: {
                // Acción para ordenar el plato
            }) {
                Text("Order Now")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(width: 150, height: 300)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

// Modifier to detect shake motion
struct ShakeDetectorModifier: ViewModifier {
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .background(ShakeDetector(action: action))
    }
}

struct ShakeDetector: UIViewControllerRepresentable {
    var action: () -> Void
    
    func makeUIViewController(context: Context) -> ShakeDetectorViewController {
        ShakeDetectorViewController(action: action)
    }
    
    func updateUIViewController(_ uiViewController: ShakeDetectorViewController, context: Context) {}
    
    class ShakeDetectorViewController: UIViewController {
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                action()
            }
        }
    }
}
