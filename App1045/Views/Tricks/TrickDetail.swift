import SwiftUI
import Combine

struct TrickDetail: View {
    
    @Binding var show: Bool
    @State var showDeleteAlert = false
    @ObservedObject var viewModel: TrickDetailViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.c606067.opacity(0.3))
                        .frame(width: 36, height: 5)
                        .padding(.top, 5)
                    header
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            Text(viewModel.trick.name)
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            images
                            complexityAndCategory
                            description
                            technic
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private var complexityAndCategory: some View {
        HStack(spacing: 8) {
            VStack(spacing: 5) {
                if viewModel.trick.complexity == 1 {
                    Text("Hard")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.c2553636)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if viewModel.trick.complexity == 2 {
                    Text("Medium")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.c25514136)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if viewModel.trick.complexity == 3 {
                    Text("Easy")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.cSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("Complexity")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c147151159)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
            .background(Color.white.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
            
            VStack(spacing: 5) {
                Text(viewModel.trick.category)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Category")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c147151159)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
            .background(Color.white.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private var description: some View {
        VStack(spacing: 10) {
            Text("Description")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.trick.description)
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
    }
    
    private var technic: some View {
        VStack(spacing: 15) {
            Text("Technic")
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.trick.technic)
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var images: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.trick.images, id: \.self) { image in
                    setImage(image.imageData)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 160)
                        .clipShape(.rect(cornerRadius: 24))
                        .clipped()
                }
            }
        }
    }
    
    private func setImage(_ data: Data) -> Image {
        guard let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
    }
    
    private var header: some View {
        ZStack {
            Text("Tricks")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 15)
            HStack {
                Button {
                    show = false
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.cSecondary)
                        
                        Text("Back")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.cSecondary)
                    }
                    .padding(.horizontal, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                HStack(spacing: 16) {
                    NavigationLink {
                        EditTrick(viewModel: ViewModelFactory.shared.makeEditTrickViewModel(viewModel.trick))
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.cSecondary)
                    }
                    Button {
                        withAnimation {
                            showDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 22)
                            .foregroundColor(.cSecondary)
                        .padding(.trailing, 16)
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("Delete"), message: Text("Are you sure you want to delete?"), primaryButton: .default(Text("Delete"), action: {
                            viewModel.delete()
                            show = false
                        }), secondaryButton: .destructive(Text("Close")))
                    }
                }
            }
        }
    }
    
}

struct TrickDetail_Preview: PreviewProvider {

    @State static var show = true
    
    static var previews: some View {
        TrickDetail(show: $show, viewModel: ViewModelFactory.shared.makeTrickDetailViewModel(Trick(uuid: UUID(), name: "Name", category: "Category", description: "Description", technic: "Technic", complexity: 3)))
    }
}

final class TrickDetailViewModel: ObservableObject {
    
    let dataC: DataC
    var trick: Trick
    
    private var tricksCancellable: AnyCancellable?
    
    init(dataC: DataC, trick: Trick) {
        self.dataC = dataC
        self.trick = trick
        
        tricksCancellable = dataC.$tricks.sink { [weak self] value in
            guard let index = value.firstIndex(where: {$0.uuid == trick.uuid}) else { return }
            self?.trick = value[index]
            self?.objectWillChange.send()
        }
    }
    
    func delete() {
        dataC.deleteTrick(trick)
    }
}
