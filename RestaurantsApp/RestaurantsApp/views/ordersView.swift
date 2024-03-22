import SwiftUI

struct ordersView: View {
    @StateObject var viewModel = OrderViewModel()
    @State private var isLoading = false // Variable de estado para controlar el indicador de carga
    
    var body: some View {
        
       // VStack(){
  //      }
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
                    
                    
                        LazyVStack(alignment: .center, spacing: UIScreen.main.bounds.height * 0.1) {
                            ForEach(viewModel.documents, id: \.self) { document in
                                if document["activa"] as? Bool == true {
                                    RestaurantCardView(document: document)
                                        .frame(width: UIScreen.main.bounds.width * 0.8)
                                                    }
                                 //   .padding(.bottom ,)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 0)
                    

                }
                .padding(.horizontal, 12)
                .padding(.bottom, 80)
                           
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
                    

                        LazyVStack(alignment: .center, spacing: UIScreen.main.bounds.height * 0.1) {
                            ForEach(viewModel.documents, id: \.self) { document in
                                if document["activa"] as? Bool == false {
                                    RestaurantCardView(document: document)
                                        .frame(width: UIScreen.main.bounds.width * 0.8)
                                                    }
                                 //   .padding(.bottom ,)
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
                        viewModel.fetchData ()
                    
        }
        .padding(.top, 24)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
    }
}

#Preview {
    ordersView()
}

