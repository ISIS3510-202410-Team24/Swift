//
//  AnalyticsView.swift
//  RestaurantsApp
//
//  Created by Juan Esteban Rodriguez Ospino on 22/03/24.
//

import SwiftUI
import FirebaseAnalytics

final class AnalyticsManager {
        
    static let shared = AnalyticsManager()
    private init() {}
    
    // Función para rastrear eventos personalizados
    func trackEvent(_ eventName: String, parameters: [String: Any]) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
    
    // Función para rastrear pantallas
    func trackScreen(_ screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }
    
    // Función para registrar un evento de inicio de sesión exitoso en Firebase Analytics
        func logSignInSuccessEvent() {
            Analytics.logEvent("login_success", parameters: nil)
        }
        
        // Función para registrar un evento de inicio de sesión fallido en Firebase Analytics
        func logSignInFailureEvent(errorDescription: String) {
            Analytics.logEvent("login_failure", parameters: ["error_description": errorDescription])
        }
        
        // Función para registrar un evento de registro exitoso en Firebase Analytics
        func logSignUpSuccessEvent() {
            Analytics.logEvent("signup_success", parameters: nil)
        }
        
        // Función para registrar un evento de registro fallido en Firebase Analytics
        func logSignUpFailureEvent(errorDescription: String) {
            Analytics.logEvent("signup_failure", parameters: ["error_description": errorDescription])
        }
        
        // Función para registrar un evento de inicio de sesión biométrica en Firebase Analytics
        func logBiometricSignInEvent() {
            Analytics.logEvent("biometric_signin", parameters: nil)
        }
}
