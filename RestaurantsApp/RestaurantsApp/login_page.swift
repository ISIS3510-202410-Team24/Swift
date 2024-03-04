//
//  login_page.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 1/03/24.
//

import SwiftUI

struct login_page: View {
    
    var body: some View {
        VStack {
            ZStack {  }
            .frame(width: 200, height: 200)
            .background(.white)

            .cornerRadius(894)
            
            
            
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                SignInView().tabItem { Text("Sign In") }.tag(1)
                SignUpView().tabItem { Text("Log In") }.tag(2)
            }.tabViewStyle(DefaultTabViewStyle())
            

        }

        .background(Color("Blue"))
    }
}


struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField("Email", text: $email)
                    .padding(15)
                    .keyboardType(.emailAddress)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.16), radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 2)
            )
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .padding(15)
                        .keyboardType(.default)
                        .disableAutocorrection(true)
                } else {
                    SecureField("Password", text: $password)
                        .padding(15)
                        .keyboardType(.default)
                        .disableAutocorrection(true)
                }
                
                Spacer()
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.16), radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 2)
            )
            
            HStack {
                Spacer()
                Text("Forgot Password?")
                    .underline(true)
            }
            
            Button("Sign in") {
                // Action
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 327, height: 52, alignment: .center)
            .background(Color(red: 0.56, green: 0.56, blue: 0.56))
            .cornerRadius(8)
        }
        .padding(10)
        
    }
}




struct SignUpView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField("Name", text: $name)
                    .padding(15)
                    .keyboardType(.emailAddress)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.16), radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 2)
            )
            
            
            
            
            
            
            
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField("Email", text: $email)
                    .padding(15)
                    .keyboardType(.emailAddress)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.16), radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 2)
            )
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .padding(15)
                        .keyboardType(.default)
                        .disableAutocorrection(true)
                } else {
                    SecureField("Password", text: $password)
                        .padding(15)
                        .keyboardType(.default)
                        .disableAutocorrection(true)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.16), radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.1, green: 0.1, blue: 0.1), lineWidth: 2)
            )
            
            
            Button("Sign up") {
                // Action
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 327, height: 52, alignment: .center)
            .background(Color(red: 0.56, green: 0.56, blue: 0.56))
            .cornerRadius(8)
        }.padding(10)

    }
}


    struct LoginPage_Previews: PreviewProvider {
        static var previews: some View {
            
            login_page()
        }
    }