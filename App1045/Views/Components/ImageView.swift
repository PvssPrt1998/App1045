import PhotosUI
import SwiftUI

struct ImageView: View {
   
    @Binding var imageData: Data?
    @State var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
            if let image = image {
                ZStack {
                    Color.white
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
                .frame(width: 164, height: 145)
                .clipShape(.rect(cornerRadius: 20))
            } else {
                Image(systemName: "camera.fill")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.cSecondary)
                    .frame(width: 164, height: 145)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .frame(width: 164, height: 145)
        .clipShape(.rect(cornerRadius: 20))
        .onTapGesture {
            showingImagePicker = true
        }
        .onChange(of: inputImage) { _ in
            loadImage()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
                .ignoresSafeArea()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        imageData = inputImage.pngData()
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
