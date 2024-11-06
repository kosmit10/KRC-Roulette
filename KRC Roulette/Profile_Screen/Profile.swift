import SwiftUI
import UIKit

struct Profile: View {
    @State private var profileImage: Image? = Image(systemName: "person.circle")
    @State private var userName: String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                profileImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .padding()
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Choice you photo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
//                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $inputImage)
                }
                
                VStack {
                    TextField("Wpisz nazwę użytkownika", text: $userName)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                    
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Button(action: {
                }) {
                    Text("Zatwierdź")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
//                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                
                Spacer() // Wypełniacz na dole, aby przyciski nie były ściśnięte
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
    
    // Załaduj wybrane zdjęcie
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }
}

// Picker do zdjęć
struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    Profile()
}
