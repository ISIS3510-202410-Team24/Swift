import SwiftUI
import Combine
struct basketView: View {
    @Binding var isShowing: Bool
    @ObservedObject var cart: Cart

    var body: some View {
        VStack {
            Text("Shopping Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            List {
                ForEach(cart.items) { item in
                    HStack {
                        Text("\(item.name) x\(item.quantity)")
                        Spacer()
                        Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                    }
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
    }
}
