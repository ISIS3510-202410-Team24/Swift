//
//  RestaurantsAppApp.swift
//  RestaurantsApp
//
//  Created by Luis Felipe Dussán 2 on 26/02/24.
//

import SwiftUI
import SwiftData
import Firebase
@main
struct RestaurantsAppApp: App {
    
    init(){
        FirebaseApp.configure()
        

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
            FirestoreManager.shared.enviarErroresEnCache()
            return true
        }

        func applicationDidBecomeActive(_ application: UIApplication) {
            FirestoreManager.shared.enviarErroresEnCache()
        }
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}


