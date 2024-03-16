import SwiftUI

struct ContentView: View {
    @State private var showProfile = false
    var body: some View {
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
