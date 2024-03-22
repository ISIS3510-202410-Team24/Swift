import SwiftUI
import Firebase
import LocalAuthentication

class LoginViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    
    @Published var alert = false
    @Published var alertMsg = ""
    
    // Función para almacenar credenciales localmente
    private func saveCredentialsLocally() {
        UserDefaults.standard.set(email, forKey: "savedEmail")
        // Aquí puedes usar Keychain para almacenar la contraseña de manera segura
        UserDefaults.standard.set(password, forKey: "savedPassword")
    }
    
    // Función para recuperar credenciales almacenadas localmente
    private func getSavedCredentials() -> (email: String, password: String)? {
        guard let savedEmail = UserDefaults.standard.string(forKey: "savedEmail"),
              let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") else {
            return nil
        }
        return (savedEmail, savedPassword)
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error.localizedDescription)
                AnalyticsManager.shared.logSignInFailureEvent(errorDescription: error.localizedDescription)
            } else {
                print("Accedio usuario")
                self.saveCredentialsLocally()
                self.isLoggedIn = true
                AnalyticsManager.shared.logSignInSuccessEvent()
            }
        }
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let user = Auth.auth().currentUser {
                    let userID = user.uid
                    FirestoreManager().agregarDocumento(coleccion: "usuario", datos: ["id": userID]) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    print("Usuario creado con ID:", userID)
                }
                self.isLoggedIn = true
            }
        }
    }
    
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Allow Face ID for authentication"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    // Autenticación biométrica exitosa, recuperar credenciales almacenadas
                    if let savedCredentials = self.getSavedCredentials() {
                        self.email = savedCredentials.email
                        self.password = savedCredentials.password
                        // Autenticar al usuario en Firebase con las credenciales recuperadas
                        self.login()
                    } else {
                        // No se encontraron credenciales almacenadas
                        print("No se encontraron credenciales almacenadas")
                    }
                } else {
                    // Problema con la autenticación biométrica
                    print("Problema con la autenticación biométrica")
                }
            }
        } else {
            // El dispositivo no admite la autenticación biométrica
            print("El dispositivo no admite la autenticación biométrica")
        }
    }
}
