import PhotosUI
import SwiftUI

struct ImageViewWithoutGesture: View {
   
    @Binding var imageData: Data?
    @State var image: Image?
    @State private var showingImagePicker = false
    @State var inputImage: UIImage?
    
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
                    .background(Color.white.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .frame(width: 164, height: 145)
        .clipShape(.rect(cornerRadius: 20))
        .onChange(of: inputImage) { _ in
            loadImage()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        imageData = inputImage.pngData()
    }
}
