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
    @State private var isRatingViewPresented = false // Estado para controlar la presentación de la vista de calificación
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(document["restaurante"] as? String ?? "Nombre del restaurante")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(document["direccion"] as? String ?? "Dirección del restaurante")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(document["valor"] as? Int ?? 0) COP")
                        .font(.subheadline)
                        .foregroundColor(blueColor)
                        .padding(.top, 4)
                    
                    HStack(spacing: 8) {
                        if let activa = document["activa"] as? Bool, !activa {
                            Button(action: {
                                // Acción para calificar el restaurante
                                isRatingViewPresented = true
                            }) {
                                Text("Calificar")
                                    .fontWeight(.medium)
                                    .font(.footnote) // Tamaño de fuente más pequeño
                                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                    .foregroundColor(.white)
                                    .background(pinkColor)
                                    .cornerRadius(16)
                            }
                            .sheet(isPresented: $isRatingViewPresented) {
                                RatingView()
                            }
                        }
                        
                        Button(action: {
                            onDelete()
                        }) {
                            Text("Eliminar")
                                .fontWeight(.medium)
                                .font(.footnote) // Tamaño de fuente más pequeño
                                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(16)
                        }
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
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 84)
                        .clipped()
                } else {
                    // Placeholder view for image not found
                    Text("Image Not Found")
                        .font(.caption)
                        .foregroundColor(.red)
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
