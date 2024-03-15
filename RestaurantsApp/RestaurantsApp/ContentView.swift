import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center) {
    
                VStack {
                    HeaderView(title: "Home", profileButtonAction: {
                        // Acción cuando se presiona el botón de perfil del usuario
                        print("Perfil del usuario consultado")
                    })

                
            }
            
            // Agrega BottomNavigationBar fuera del NavigationView
            BottomNavigationBar()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
