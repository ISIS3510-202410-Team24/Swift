import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

import SwiftUI
import UIKit

struct RatingView: View {
    @State private var comment: String = "" // Estado para almacenar el comentario
    @State private var rating: Int = 0 // Estado para almacenar la calificación
    @State private var selectedImage: UIImage? // Estado para almacenar la imagen seleccionada
    @State private var isShowingImagePicker = false // Estado para controlar la presentación del selector de imágenes
    @Environment(\.presentationMode) var presentationMode // Variable de entorno para el modo de presentación
    
    let maxCommentLength = 100 // Límite máximo de caracteres para el comentario
    
    var body: some View {
        VStack {
            Text("Please rate your order")
                .font(.title)
            
            // Selector de estrellas para la calificación
            HStack {
                ForEach(1..<6) { index in
                    Button(action: {
                        rating = index
                    }) {
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.system(size: 30))
                            .onTapGesture {
                                rating = index
                            }
                    }
                }
            }
            
            // Campo de texto para el comentario
            TextEditor(text: $comment)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .frame(minHeight: 100, maxHeight: 200) // Altura mínima y máxima de la caja de texto
                .padding(.horizontal)
                .onChange(of: comment) { newValue in
                    // Limitar la longitud del comentario
                    if newValue.count > maxCommentLength {
                        comment = String(newValue.prefix(maxCommentLength))
                    }
                }
            
            // Contador de caracteres
            Text("\(comment.count)/\(maxCommentLength)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            // Botón para seleccionar una foto
            Button(action: {
                isShowingImagePicker = true
            }) {
                Text("Subir Foto")
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(.white)
                    .background(backroundColor)
                    .cornerRadius(8)
            }
            
            // Mostrar la imagen seleccionada
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            // Botón para guardar los datos y cerrar la vista
            Button(action: {
                // Lógica para guardar los datos y cerrar la vista
                saveRating()
            }) {
                Text("Guardar")
                    .fontWeight(.medium)
                    .padding()
                    .foregroundColor(.white)
                    .background(pinkColor)
                    .cornerRadius(8)
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, isPresented: $isShowingImagePicker)
        }
    }
    
    func saveRating() {
        // Aquí puedes implementar la lógica para guardar la calificación, el comentario y la foto
        // Luego, cierra la vista
        presentationMode.wrappedValue.dismiss()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No es necesario implementar esto
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }
    }
}
