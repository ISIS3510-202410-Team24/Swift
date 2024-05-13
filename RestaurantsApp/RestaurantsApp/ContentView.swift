import SwiftUI


struct ContentView: View {
    @State private var showProfile = false
    @State private var showBasket = false
    @StateObject var loginModel = LoginViewModel()
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
                
                BottomNavigationBar()
            }
            SideProfileView(isShowing: $showProfile)
            basketView(isShowing: $showBasket)
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
