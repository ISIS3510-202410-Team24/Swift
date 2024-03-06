//
//  Search_page.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán on 4/03/24.
//

import SwiftUI

struct Search_page: View {
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            // Search Bar
            SearchBar(text: $searchText)
                .background(Color(red: 0.4, green: 0.7, blue: 0.7))
            
            
            
            Text("Food")
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                            .bold()
                            .padding(.bottom, 20)
                            .position()
                            .padding(35)
                            .offset(x:30)
            Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .frame(width: 350)
                            .padding(.vertical, 20)
            
            Text("Salad")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                            .position()
                            .padding(35)
                            .offset(x:30)
            
            Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .frame(width: 350)
                            .padding(.vertical, 20)
            
            Text("Ramen")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                            .position()
                            .padding(35)
                            .offset(x:30)
            
            Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .frame(width: 350)
                            .padding(.vertical, 20)
            Text("Pizza")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                            .position()
                            .padding(35)
                            .offset(x:30)
            
            Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .frame(width: 350)
                            .padding(.vertical, 20)
            
            Text("Hamburger")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                            .position()
                            .padding(35)
                            .offset(x:70)
            
            Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .frame(width: 350)
                            .padding(.vertical, 20)
                        
            // TabView or other content
            TabView(selection: .constant(1)) {
                // TabView items
            }
            .tabViewStyle(DefaultTabViewStyle())
        }
        .background(Color("White"))
    }
}

struct Search_pagePreview: PreviewProvider {
    static var previews: some View {
        Search_page()
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            
            Image(systemName: "arrow.left")
                                .foregroundColor(.blue)
                                .font(.title)
                                .onTapGesture {
                                    // Add action when arrow is tapped
                                    print("Arrow tapped!")
                                }
                        
            TextField("Search your food", text: $text)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(10)
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
        
     
    }
}
