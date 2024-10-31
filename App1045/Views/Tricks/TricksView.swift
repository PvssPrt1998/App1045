import SwiftUI

struct TricksView: View {
    
    @ObservedObject var viewModel: TricksViewModel = ViewModelFactory.shared.makeTricksViewModel()
    
    @State var newTrick = false
    @State var trickDetail = false
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                header
                stat
                    .padding(.top, 16)
                if viewModel.tricks.isEmpty {
                    emptyTricks
                        .padding(.top, 85)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(viewModel.tricks, id: \.self) { trick in
                            trickCard(trick)
                                .onTapGesture {
                                    viewModel.trickForShow = trick
                                    trickDetail = true
                                }
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.top, 29)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .sheet(isPresented: $newTrick, content: {
            NewTrick(show: $newTrick)
        })
        .sheet(isPresented: $trickDetail, content: {
            TrickDetail(show: $trickDetail, viewModel: ViewModelFactory.shared.makeTrickDetailViewModel(viewModel.trickForShow!))
        })
        
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("Tricks")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 8, trailing: 0))
                .frame(maxWidth: .infinity, alignment: .leading)
            if !viewModel.tricks.isEmpty {
                Button {
                    newTrick = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    private func trickCard(_ trick: Trick) -> some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(trick.images, id: \.self) { imageData in
                        setImage(imageData.imageData)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 89, height: 90)
                            .clipShape(.rect(cornerRadius: 12))
                            .clipped()
                    }
                    .padding(.bottom, 16)
                }
            }
            if trick.complexity == 1 {
                Text("Hard")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c11510)
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .background(Color.c1972073)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else if trick.complexity == 2 {
                Text("Medium")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c11510)
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .background(Color.c25514136)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else if trick.complexity == 3 {
                Text("Easy")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c11510)
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .background(Color.cSecondary)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 6) {
                Text(trick.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(trick.description)
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c241249245.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
        .background(Color.c241249245.opacity(0.08))
        .clipShape(.rect(cornerRadius: 24))
    }
    
    private var stat: some View {
        HStack(spacing: 12) {
            totalAmount
            
            VStack(spacing: 8) {
                easy
                medium
                hard
            }
        }
    }
    
    private var totalAmount: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.c1972073)
                    .frame(width: 48, height: 48)
                Text("\(viewModel.tricks.count)")
                    .font(.title.weight(.regular))
                    .foregroundColor(.c241249245.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Text("Tricks")
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .padding(12)
        .frame(height: 163)
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
    private func setImage(_ data: Data) -> Image {
        guard let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
    }
    
    private var easy: some View{
        HStack(spacing: 0) {
            Text("Easy")
                .font(.caption.weight(.medium))
                .foregroundColor(.c11510)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(Color.cSecondary)
                .clipShape(.rect(cornerRadius: 12))
            Text("\(viewModel.tricks.filter {$0.complexity == 3}.count)")
                .font(.title3.weight(.regular))
                .foregroundColor(.c247251249)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 12)
        .frame(height: 49)
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
    
    private var medium: some View {
        HStack(spacing: 0) {
            Text("Medium")
                .font(.caption.weight(.medium))
                .foregroundColor(.c11510)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(Color.c25514136)
                .clipShape(.rect(cornerRadius: 12))
            Text("\(viewModel.tricks.filter {$0.complexity == 2}.count)")
                .font(.title3.weight(.regular))
                .foregroundColor(.c247251249)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 12)
        .frame(height: 49)
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
    
    private var hard: some View {
        HStack(spacing: 0) {
            Text("Hard")
                .font(.caption.weight(.medium))
                .foregroundColor(.c11510)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(Color.c1972073)
                .clipShape(.rect(cornerRadius: 12))
            Text("\(viewModel.tricks.filter {$0.complexity == 1}.count)")
                .font(.title3.weight(.regular))
                .foregroundColor(.c247251249)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 12)
        .frame(height: 49)
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
    private var emptyTricks: some View {
        VStack {
            VStack(spacing: 5) {
                Text("Create new tricks")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Text("Your tricks will be shown here")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.white.opacity(0.3))
                    .multilineTextAlignment(.center)
                Button {
                    newTrick = true
                } label: {
                    Text("Click to create")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 228, height: 40)
                        .background(Color.cPrimary)
                        .clipShape(.rect(cornerRadius: 12))
                }
            }
        }
    }
}

struct TricksView_Preview: PreviewProvider {
    
    static var previews: some View {
        TricksView()
    }
}
