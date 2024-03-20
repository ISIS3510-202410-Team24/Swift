//
//  LoginViewModel.swift
//  RestaurantsApp
//
//  Created by Estudiantes on 20/03/24.
//

import SwiftUI
import Firebase


class LoginViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password=""
    @Published var isLoggedIn = false
    
    @Published var alert = false
    @Published var alertMsg=""
    
    
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password){result, error in
            if error != nil{
                print(error!.localizedDescription)
            }else{
                self.isLoggedIn.toggle()
            }}
        
    }
    
    
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                if let user = result?.user {
                    // El usuario se ha creado exitosamente
                    let userID = user.uid
                    FirestoreManager().agregarDocumento(coleccion:"usuario",datos:["id":userID]){error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                    }
                    print("Usuario creado con ID:", userID)}
                
                
                self.isLoggedIn.toggle()
                
            }}
    }
    
}
