import SwiftUI

struct BasketView: View {
    @Binding var isShowing: Bool
    @ObservedObject var cart: Cart
    @State private var showAlert = false // Estado para controlar la visibilidad de la alerta


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                
                HStack {
                    VStack {
                        Spacer() // Empuja el contenido hacia abajo

                        VStack(alignment: .leading) {
                            Text("Shopping Cart")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.bottom, 20)
                            
                            ScrollView {
                                ForEach(cart.items) { item in
                                    HStack {
                                        Text(item.name)
                                        Spacer()
                                        Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .frame(maxHeight: geometry.size.height * 0.5) // Limita la altura del scroll

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
                            .padding(.bottom, 20)
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.8)
                        .background(Color(red: 0.51, green: 0.77, blue: 0.75))
                        .cornerRadius(20)
                        .shadow(radius: 5)

                        Spacer() // Empuja el contenido hacia arriba
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.8)
                    .background(Color(red: 0.51, green: 0.77, blue: 0.75))
                    .cornerRadius(20)
                    .shadow(radius: 5)

                    Spacer() // Empuja el contenido hacia la izquierda
                }
            }
            .alert(isPresented: $showAlert) {
                        Alert(title: Text("No Internet Connection"), message: Text("Please check your internet connection and try again."), dismissButton: .default(Text("OK")))
                    }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear { checkCart() }
        
    }

    func checkCart() {
        print(cart.items.count)
    }
}
