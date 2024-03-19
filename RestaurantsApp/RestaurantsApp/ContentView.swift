import SwiftUI


struct ContentView: View {
    @State private var showProfile = false
    @State private var isLoggedIn1 = false
    var body: some View {
        
        if isLoggedIn1{
            return AnyView(content)
        } else {
            return AnyView(login_page(isLoggedIn: $isLoggedIn1))
        }
        
    }
    var content: some View {
        ZStack {
            VStack(alignment: .center) {
        
                    VStack {
                        HeaderView(title: "Home", profileButtonAction: {
                            showProfile.toggle()
                        })

                    
                }
                
                BottomNavigationBar()
            }
            SideProfileView(isShowing: $showProfile)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
