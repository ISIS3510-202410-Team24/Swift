import SwiftUI

struct ordersView: View {
    @StateObject var viewModel = OrderViewModel()
    @State private var isLoading = false
    @State private var activeOrdersCount = 0
    @State private var inactiveOrdersCount = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current orders")
                        .font(Font.custom("Roboto", size: 22))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    Text("Check the state of your orders")
                        .font(Font.custom("Roboto", size: 14).weight(.medium))
                        .kerning(0.1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("Active Orders: \(activeOrdersCount)")
                        .font(Font.custom("Roboto", size: 14).weight(.medium))
                        .padding(.bottom, 8)
                        .foregroundColor(pinkColor)
                    
                    LazyVStack(alignment: .center, spacing: UIScreen.main.bounds.height * 0.15) {
                        ForEach(viewModel.documents, id: \.self) { document in
                            if let activa = document["activa"] as? Bool, activa {
                                RestaurantCardView(document: document) {
                                    // Closure para eliminar la orden
                                    viewModel.deleteOrder(document)
                                    activeOrdersCount -= 1 // Disminuir el contador
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.8)
                                .onAppear {
                                    // No necesitas aumentar el contador aquí
                                }
                            }
                        }
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 0)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 100)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("History of orders")
                        .font(Font.custom("Roboto", size: 22))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    Text("Check your latest orders and restaurants")
                        .font(Font.custom("Roboto", size: 14).weight(.medium))
                        .kerning(0.1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("Inactive Orders: \(inactiveOrdersCount)")
                        .font(Font.custom("Roboto", size: 14).weight(.medium))
                        .padding(.bottom, 8)
                        .foregroundColor(pinkColor)
                    
                    LazyVStack(alignment: .center, spacing: UIScreen.main.bounds.height * 0.15) {
                        ForEach(viewModel.documents, id: \.self) { document in
                            if let activa = document["activa"] as? Bool, !activa {
                                RestaurantCardView(document: document) {
                                    // Closure para eliminar la orden
                                    viewModel.deleteOrder(document)
                                    inactiveOrdersCount -= 1 // Disminuir el contador
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.8)
                                .onAppear {
                                    // No necesitas aumentar el contador aquí
                                }
                            }
                        }
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 0)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 0)
            }
        }
        .onAppear {
            AnalyticsManager.shared.trackScreen("ordersView")
            isLoading = true
            viewModel.fetchData {
                // Esta parte del código se ejecutará después de que se hayan cargado los documentos correctamente
                // Aquí puedes actualizar los contadores u realizar otras operaciones necesarias
                
                // Reiniciamos los contadores
                activeOrdersCount = 0
                inactiveOrdersCount = 0
                
                // Iteramos sobre los documentos cargados
                for document in viewModel.documents {
                    if let data = document.data(), let activa = data["activa"] as? Bool {
                        if activa {
                            activeOrdersCount += 1
                        } else {
                            inactiveOrdersCount += 1
                        }
                    }
                }
                isLoading = false
            }


        }
        .padding(.top, 24)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
    }
}

 
struct ordersView_Previews: PreviewProvider {
    static var previews: some View {
        ordersView()
    }
}
