import SwiftUI
import Combine

struct CartItem: Identifiable {
    let id: String
    let name: String
    let price: Double
    var quantity: Int
}

class Cart: ObservableObject {
    @Published var items: [CartItem] = []

    func addItem(_ item: MenuItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += 1
        } else {
            let cartItem = CartItem(id: item.id, name: item.name, price: item.price, quantity: 1)
            items.append(cartItem)
        }
    }

    func removeItem(_ item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
            } else {
                items.remove(at: index)
            }
        }
    }

    func clearCart() {
        items.removeAll()
    }

    var total: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}
