import SwiftUI
import FirebaseFirestore
import Kingfisher

// Colors
let backroundColor = Color(UIColor(named: "Background")!)
let blueColor = Color(UIColor(named: "Blue")!)
let pinkColor = Color(UIColor(named: "Pink")!)

struct RestaurantCardView: View {
    var document: DocumentSnapshot // El documento obtenido de Firestore
    var onDelete: () -> Void // Closure que se ejecutará cuando se elimine la orden
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                VStack (alignment: .leading){
                    Text(document["restaurante"] as? String ?? "Nombre del restaurante")
                        .font(Font.custom("Roboto", size: 16))
                        .fontWeight(.bold)
                        .kerning(0.5)
                        .foregroundColor(.black)
                    Text(document["direccion"] as? String ?? "Nombre del restaurante")
                        .font(Font.custom("Roboto", size: 16))
                        .kerning(0.5)
                        .foregroundColor(.black)
                    Text("\(document["valor"] as? Int ?? 0) COP")
                        .font(Font.custom("Roboto", size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundColor(blueColor)
                    
                    Button(action: {
                        onDelete()
                    }) {
                        Text("Delete")
                            .fontWeight(.medium)
                            .font(Font.custom("Roboto", size: 11))
                            .kerning(0.5)
                            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(32)
                    }
                    .padding(.top, 8)
                }
                Spacer()
                if let imageURLString = document["producto"] as? String,
                   let imageURL = URL(string: imageURLString) {
                    KFImage(imageURL)
                        .placeholder {
                            // Placeholder view while loading
                            ProgressView()
                        }
                        .onFailure { error in
                            // Placeholder view on failure
                            Text("Failed to load image: \(error.localizedDescription)")
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 84)
                        .clipped()
                } else {
                    // Placeholder view for image not found
                    Text("Image Not Found")
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(backroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
}
