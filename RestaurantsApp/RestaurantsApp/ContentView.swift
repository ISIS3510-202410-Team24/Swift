import SwiftUI


struct ContentView: View {
    @State private var showProfile = false
    @State private var showBasket = false
    @StateObject var loginModel = LoginViewModel()
    @StateObject var restauranteViewModel = RestaurantViewModel()
    @StateObject var mapViewModel = MapViewModel()
    @StateObject var cart = Cart() // Agrega el carrito de compras como un StateObject

    var body: some View {
        
        if loginModel.isLoggedIn{
            return AnyView(content)
        } else {
            return AnyView(login_page(LoginModel: loginModel))
        }
        
    }
    var content: some View {
        ZStack {
            VStack(alignment: .center) {
        
                    VStack {
                        HeaderView(title: "FoodU", profileButtonAction: {
                            showProfile.toggle()
                        }, basketButtonAction: {
                            showBasket.toggle()
                        }
                       
                        )

                    
                }
                
                BottomNavigationBar(cart: cart,restaurnatViewModel: restauranteViewModel,mapViewModel: mapViewModel)
            }
            SideProfileView(isShowing: $showProfile)
            if showBasket {
                            BasketView(isShowing: $showBasket,cart: cart ) // Pasa el carrito y el binding del estado
                        }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
