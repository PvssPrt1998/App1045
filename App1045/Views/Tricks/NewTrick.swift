import SwiftUI

struct NewTrick: View {
    
    @Binding var show: Bool
    @ObservedObject var viewModel: NewTrickViewModel = ViewModelFactory.shared.makeNewTrickViewModel()
    @State var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.c606067.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                ZStack {
                    Text("New tricks")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        name
                        photo
                        Button {
                            showingImagePicker = true
                        } label: {
                            Text("Add photos")
                                .font(.body.weight(.regular))
                                .foregroundColor(Color.c232426)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.cSecondary)
                                .clipShape(.rect(cornerRadius: 100))
                        }
                        complexity
                        category
                        description
                        technic
                        Button {
                            viewModel.addPressed()
                            show = false
                        } label: {
                            Text("Add")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .frame(height: 40)
                                .background(Color.cPrimary)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                        .disabled(viewModel.disabled)
                        .opacity(viewModel.disabled ? 0.6 : 1)
                    }
                    .padding(EdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16))
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
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
        guard let data = inputImage.pngData() else { return }
        viewModel.images.append(TrickImage(uuid: viewModel.uuid, imageUUID: UUID(), imageData: data))
    }
    
    private func setImage(_ data: Data) -> Image {
        guard let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
    }
    
    private var name: some View {
        VStack(spacing: 9) {
            Text("Name")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.name, needPrefix: false, prefix: "prefix", placeholder: "Enter name tricks")
        }
    }
    private var photo: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                if viewModel.images.isEmpty {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.cSecondary)
                        .frame(width: 192, height: 170)
                        .background(Color.white.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 24))
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.cSecondary)
                        .frame(width: 192, height: 170)
                        .background(Color.white.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 24))
                } else {
                    ForEach(viewModel.images, id: \.self) { imageData in
                        setImage(imageData.imageData)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 192, height: 170)
                            .clipShape(.rect(cornerRadius: 24))
                            .clipped()
                            .overlay(
                                Button {
                                    viewModel.removeImage(imageData)
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.c241249245.opacity(0.7))
                                        .frame(width: 30, height: 30)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(.circle)
                                }
                                    .padding(10)
                                ,alignment: .topTrailing
                            )
                    }
                }
            }
            .clipShape(.rect(cornerRadius: 24))
        }
        .clipShape(.rect(cornerRadius: 24))
    }
    private var complexity: some View {
        HStack(spacing: 10) {
            Text("Complexity")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
            
            Text("Hard")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.c2553636)
                .frame(width: 75, height: 50)
                .background(Color.c353643)
                .clipShape(.rect(cornerRadius: 12))
                .opacity(viewModel.complexity == 1 ? 1 : 0.3)
                .onTapGesture {
                    viewModel.complexity = 1
                }
            Text("Medium")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.c25514136)
                .frame(width: 75, height: 50)
                .background(Color.c353643)
                .clipShape(.rect(cornerRadius: 12))
                .opacity(viewModel.complexity == 2 ? 1 : 0.3)
                .onTapGesture {
                    viewModel.complexity = 2
                }
            Text("Easy")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.cSecondary)
                .frame(width: 75, height: 50)
                .background(Color.c353643)
                .clipShape(.rect(cornerRadius: 12))
                .opacity(viewModel.complexity == 3 ? 1 : 0.3)
                .onTapGesture {
                    viewModel.complexity = 3
                }
        }
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var category: some View {
        VStack(spacing: 9) {
            Text("Category")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.category, needPrefix: false, prefix: "prefix", placeholder: "Enter category tricks")
        }
    }
    private var description: some View {
        VStack(spacing: 9) {
            Text("Description")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.description, needPrefix: false, prefix: "prefix", placeholder: "Enter description tricks")
        }
    }
    private var technic: some View {
        VStack(spacing: 9) {
            Text("Technic")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.technic, needPrefix: false, prefix: "prefix", placeholder: "Enter technic tricks")
        }
    }
}

struct NewTrick_Preview: PreviewProvider {

    @State static var show = true
    
    static var previews: some View {
        NewTrick(show: $show)
    }
}

final class NewTrickViewModel: ObservableObject {
    
    let dataC: DataC
    let uuid = UUID()
    
    var disabled: Bool {
        name == "" || complexity == 0 || category == "" || description == "" || technic == "" || images.isEmpty
    }
    
    @Published var imageData: Data?
    @Published var name = ""
    @Published var images: Array<TrickImage> = []
    @Published var complexity = 0
    @Published var category = ""
    @Published var description = ""
    @Published var technic = ""
    
    init(dataC: DataC) {
        self.dataC = dataC
    }
    
    func addPressed() {
        let trick = Trick(uuid: uuid, name: name, category: category, description: description, technic: technic, complexity: complexity, images: images)
        dataC.addTrick(trick)
    }
    
    func removeImage(_ trickImage: TrickImage) {
        guard let index = images.firstIndex(where: {$0.imageUUID == trickImage.imageUUID}) else { return }
        images.remove(at: index)
    }
}
