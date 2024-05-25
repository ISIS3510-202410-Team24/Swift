import SwiftUI

struct BasketView: View {
    @Binding var isShowing: Bool
    @ObservedObject var cart: Cart

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                HStack {
                    Spacer().frame(height: 20)
                    VStack {
                        Text("Shopping Cart")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                                ForEach(cart.items) { item in
                                HStack {
                                    
                                    Text(item.name)
                                    //Spacer()
                                    //Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                                }
                            }
                        
                        Text("Total: $\(cart.total, specifier: "%.2f")")
                            .font(.headline)
                            .padding(.top, 20)
                        
                        Button(action: {
                            cart.clearCart()
                        }) {
                            Text("Clear Cart")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(Color(red: 0.51, green: 0.77, blue: 0.75))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear{checkCart()}
    }
    
    func checkCart() {
        print(cart.items.count)
    }
}
