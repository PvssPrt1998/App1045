
import SwiftUI

struct EditProfileView: View {
    
    @ObservedObject var viewModel = ViewModelFactory.shared.makeEditProfileViewModel()
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.c606067.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                Text("Edit profile")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        textFields
                        choseViews
                        Button {
                            viewModel.savePressed(viewModel.imageData)
                            show = false
                        } label: {
                            Text("Save")
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
                    .padding(.bottom, 20)
                }
                .padding(.top, 33)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var textFields: some View {
        VStack(spacing: 15) {
            ImageView(imageData: $viewModel.imageData, image: setImage())
            CustomTF(text: $viewModel.name, prefix: "Name", placeholder: "Enter")
            CustomTF(text: $viewModel.age, prefix: "Age category", placeholder: "Enter")
        }
    }
    private func setImage() -> Image? {
        if let imageData = viewModel.imageData,
           let image = UIImage(data: imageData) {
            return Image(uiImage: image)
        } else {
            return nil
        }
    }
    private var choseViews: some View {
        HStack(spacing: 10) {
            VStack(spacing: 0) {
                Image("Skate")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 86, height: 113)
                Text("I'm riding for my\nown pleasure")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(EdgeInsets(top: 21, leading: 14, bottom: 24, trailing: 14))
            .frame(height: 200)
            .background(Color.white.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(viewModel.isOwn == true ? Color.cSecondary : .clear)
            )
            .onTapGesture {
                if viewModel.isOwn == true {
                    viewModel.isOwn = nil
                } else {
                    viewModel.isOwn = true
                }
            }
            
            VStack(spacing: 0) {
                Image("Trophy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 86, height: 113)
                Text("I have sponsors")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(EdgeInsets(top: 21, leading: 14, bottom: 24, trailing: 14))
            .frame(height: 200)
            .background(Color.white.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(viewModel.isOwn == false ? Color.cSecondary : .clear)
            )
            .onTapGesture {
                if viewModel.isOwn == false {
                    viewModel.isOwn = nil
                } else {
                    viewModel.isOwn = false
                }
            }
        }
    }
}

final class EditProfileViewModel: ObservableObject {
    
    let dataC: DataC
    
    var disabled: Bool {
        name == "" || age == "" || isOwn == nil || imageData == nil
    }
    
    @Published var imageData: Data?
    @Published var name: String
    @Published var age: String
    @Published var isOwn: Bool?
    
    init(dataC: DataC) {
        self.dataC = dataC
        
        //imageData = dataC.accountImage
        name = dataC.name
        age = dataC.age
        isOwn = dataC.isOwn
    }
    
    func savePressed(_ data: Data?) {
        dataC.accountImage = data
        dataC.name = name
        dataC.age = age
        dataC.isOwn = isOwn
        dataC.saveAccount()
        dataC.saveChoice()
    }
}
