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
        VStack(alignment: .leading) { // Envolver en un VStack
            Text("Favorites") // Título
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.top)
            
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
            
            WebImage(url: URL(string: dish.image)) { image in
                         image
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                     } placeholder: {
                         // Placeholder mientras se carga la imagen
                         ProgressView()
                     }

            
            HStack {
                Text(String(format: "%.1f", dish.rating))
                    .foregroundColor(Color.yellow)
                    .font(.headline)
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            }
            .padding(.horizontal)
            
            Text(dish.name)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            Text("$\(dish.price, specifier: "%.2f")") // Cambiar la precisión del precio
                .foregroundColor(Color.gray)
                .padding(.horizontal)
            
            Button(action: {
                // Acción para ordenar el plato
            }) {
                Text("Ordenar")
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
        .frame(width: 150, height: 300) // Ajustar la altura del frame
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
