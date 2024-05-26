//
//  homeView.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 15/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject var viewModel: FavoritesViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
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
        }
        .onAppear {
            viewModel.fetchFavoriteDishes()
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
