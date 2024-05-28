//
//  SwiftUIView.swift
//  RestaurantsApp
//
//  Created by Juan Esteban Rodriguez Ospino on 27/05/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ReportErrorView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var errorMessage: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingNoInternetAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Report an Error")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("If you encounter any issues or errors, please describe them below. Your feedback helps us improve our app!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()

                TextField("Describe the issue", text: $errorMessage)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding()

                Button(action: {
                    if Reachability.isConnectedToNetwork() {
                        enviarReporteError()
                    } else {
                        showingNoInternetAlert = true
                        enviarReporteError()
                    }
                }) {
                    Text("Submit")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                        if alertMessage == "Error reported successfully" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
                .alert(isPresented: $showingNoInternetAlert) {
                    Alert(title: Text("No Internet Connection"), message: Text("The error report will be sent later when you have an internet connection."), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Report Error", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func enviarReporteError() {
        guard !errorMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a message."
            showingAlert = true
            return
        }
        
        let datos = ["mensaje": errorMessage, "timestamp": Timestamp()] as [String : Any]
        
        FirestoreManager.shared.agregarDocumento(coleccion: "errores", datos: datos) { error in
            if let error = error {
                alertMessage = "Failed to report error: \(error.localizedDescription)"
            } else {
                alertMessage = "Error reported successfully"
            }
            showingAlert = true
        }
    }
}







#Preview {
    ReportErrorView()
}
