import SwiftUI

struct ordersView: View {
    @StateObject var viewModel = OrderViewModel()
    
    var body: some View {
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
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 0)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.documents, id: \.self) { document in
                        RestaurantCardView(document: document)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 0)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("History of orders")
                    .font(Font.custom("Roboto", size: 22))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Text("Check your latest orders and restaurants")
                    .font(Font.custom("Roboto", size: 14).weight(.medium))
                    .kerning(0.1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 0)
        }
        .onAppear {
            viewModel.fetchData()
        }
        .padding(.top, 24)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
    }
}
