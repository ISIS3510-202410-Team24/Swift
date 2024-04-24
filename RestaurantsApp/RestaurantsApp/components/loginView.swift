//
//  login_page.swift
//  RestaurantsApp
//
//  Created by Villamil Pachon Leonidas on 1/03/24.
//

import SwiftUI
import Firebase

struct login_page: View {
    
    @ObservedObject var LoginModel: LoginViewModel
    

    var body: some View {
        VStack {
            
            TabView(selection: .constant(1)) {
                SignInView(LoginModel: LoginModel)
                    .tabItem {
                        Text("Sign In")
                            .font(.headline)
                    }
                    .tag(1)
                    .frame(maxWidth: .infinity) // Ajustar el maxWidth de la pestaña
                
                SignUpView(LoginModel : LoginModel)
                    .tabItem {
                        Text("Sign Up")
                            .font(.largeTitle)
                    }
                    .tag(2)
                    .frame(maxWidth: .infinity) // Ajustar el maxWidth de la pestaña
            }.imageScale(.large)
            
        }.edgesIgnoringSafeArea(.top)
        
        .background(Color(red: 224/255, green: 226/255, blue: 231/255))    }
}


struct SignInView: View {
    @ObservedObject var LoginModel: LoginViewModel

    @State private var isPasswordVisible = false
    @State private var userIsLoggedIn = false
    @State private var maxLength = 20
    var body: some View {

            
            VStack(spacing: 20) {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 360, height: 360)
                  .background(
                    Image("login_image")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 360, height: 360)
                      .clipped()
                  )
                Spacer()

                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    
                    TextField("Email", text: $LoginModel.email)
                        .autocapitalization(.none)
                        .onChange(of: LoginModel.email) { newValue in
                                if newValue.count > maxLength {
                                    LoginModel.email = String(newValue.prefix(maxLength))
                                }
                            }
                        .padding(15)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)

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
                        TextField("Password", text: $LoginModel.password)
                        
                        
                            .padding(15)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                    } else {
                        SecureField("Password", text: $LoginModel.password)
                            .onChange(of: LoginModel.password) { newValue in
                                    if newValue.count > maxLength {
                                        LoginModel.password = String(newValue.prefix(maxLength))
                                    }
                                }
                            
                            .padding(15)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(pinkColor)
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
                    LoginModel.login()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(width: 327, height: 52, alignment: .center)
                .background(backroundColor)
                .cornerRadius(8)
                
                
                if LoginModel.isError {
                                Text(LoginModel.errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }
            }.edgesIgnoringSafeArea(.top)
            .onAppear(perform:LoginModel.authenticate)
        .padding(10)
        
        
    }
    
}




struct SignUpView: View {
    @ObservedObject var LoginModel: LoginViewModel
    @State private var name = ""
    @State private var isPasswordVisible = false
    @State private var maxLength = 20
    var body: some View {
        VStack(spacing: 20) {
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 360, height: 360)
              .background(
                Image("login_image")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 360, height: 360)
                  .clipped()
              )
            Spacer()
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField("Name", text: $name)
                    .onChange(of: LoginModel.email) { newValue in
                            if newValue.count > maxLength {
                                LoginModel.email = String(newValue.prefix(maxLength))
                            }
                        }
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
                
                TextField("Email", text: $LoginModel.email)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .onChange(of: LoginModel.email) { newValue in
                        if newValue.count > maxLength {
                            LoginModel.email = String(newValue.prefix(maxLength))
                        }
                    }
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
                    TextField("Password", text: $LoginModel.password)
                        .onChange(of: LoginModel.password) { newValue in
                            if newValue.count > maxLength {
                                LoginModel.password = String(newValue.prefix(maxLength))
                            }
                        }
                        .padding(15)
                        .keyboardType(.default)
                        .disableAutocorrection(true)
                } else {
                    SecureField("Password", text: $LoginModel.password)
                    
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
                LoginModel.register()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 327, height: 52, alignment: .center)
            .background(backroundColor)
            .cornerRadius(8)
            if LoginModel.isError {
                            Text(LoginModel.errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
            
        }.padding(10)
        
        
        
        
    }
    
}


    struct LoginPage_Previews: PreviewProvider {
        static var previews: some View {
            
            login_page(LoginModel: LoginViewModel())
        }
    }
