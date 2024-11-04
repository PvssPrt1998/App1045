import SwiftUI
import StoreKit
import Combine

struct Settings: View {
    
    @StateObject var viewModel = ViewModelFactory.shared.settingsViewModel()
    @Environment(\.openURL) var openURL
    @State var showEditProfile = false
    @State var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        HStack(spacing: 16) {
                            Button {
                                showEditProfile = true
                            } label: {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 22)
                                    .foregroundColor(.white)
                            }
                            
                            if !viewModel.isAccountEmpty {
                                Button {
                                    withAnimation {
                                        showDeleteAlert = true
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 22)
                                        .foregroundColor(.white)
                                }
                                .alert(isPresented: $showDeleteAlert) {
                                    Alert(title: Text("Delete"), message: Text("Are you sure you want to delete?"), primaryButton: .default(Text("Delete"), action: {
                                        viewModel.delete()
                                    }), secondaryButton: .destructive(Text("Close")))
                                }
                            }
                        }
                        ,alignment: .trailing
                    )
                    .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack(spacing: 17) {
                            if viewModel.imageData == nil {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(.cSecondary)
                                    .frame(width: 164, height: 145)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(.rect(cornerRadius: 20))
                            } else {
                                setImage(viewModel.imageData)
                                    .resizable()
                                    .scaledToFill()
                                    .clipped().frame(width: 164, height: 145)
                                    .clipShape(.rect(cornerRadius: 20))
                            }
                            
                            if viewModel.name != "" && viewModel.age != "" {
                                VStack(spacing: 8) {
                                    Text(viewModel.name)
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(viewModel.age)
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 16))
                        if viewModel.isOwn != nil {
                            if viewModel.isOwn == true {
                                HStack(spacing: 8) {
                                    Image("Skate")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 86, height: 113)
                                    Text("I'm riding for my\nown pleasure")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(EdgeInsets(top: 17, leading: 0, bottom: 17, trailing: 0))
                            } else {
                                HStack(spacing: 8) {
                                    Image("Trophy")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 86, height: 113)
                                    Text("I have sponsors")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(EdgeInsets(top: 17, leading: 0, bottom: 17, trailing: 0))
                            }
                        }
                        HStack(spacing: 20) {
                            Button {
                                SKStoreReviewController.requestReviewInCurrentScene()
                            } label: {
                                VStack(spacing: 5) {
                                    Image(systemName: "star.fill")
                                        .font(.subheadline)
                                        .foregroundColor(.cSecondary)
                                        .frame(width: 32, height: 32)
                                    Text("Rate app")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.cSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(Color.cPrimary)
                                .clipShape(.rect(cornerRadius: 10))
                            }
                            Button {
                                actionSheet()
                            } label: {
                                VStack(spacing: 5) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.subheadline)
                                        .foregroundColor(.cSecondary)
                                        .frame(width: 32, height: 32)
                                    Text("Share app")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.cSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(Color.cPrimary)
                                .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                        Button {
                            if let url = URL(string: "https://www.termsfeed.com/live/0c8a0e38-f756-4c76-95af-748db3c11fdf") {
                                openURL(url)
                            }
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: "doc.text.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.cSecondary)
                                    .frame(width: 32, height: 32)
                                Text("Usage Policy")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.cSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .background(Color.cPrimary)
                            .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .sheet(isPresented: $showEditProfile, content: {
            EditProfileView(show: $showEditProfile)
        })
    }
    
    private func setImage(_ data: Data?) -> Image {
        guard let data = data,
            let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/us/app/esport-skate-sorte-evolution/id6737522499")  else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        if #available(iOS 15.0, *) {
            UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
        
    }
}

#Preview {
    Settings()
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}

final class SettingsViewModel: ObservableObject {
    
    let dataC: DataC
    
    var isAccountEmpty: Bool {
        name == "" && age == "" && imageData == nil && isOwn == nil
    }
    
    @Published var name: String
    @Published var age: String
    @Published var imageData: Data?
    @Published var isOwn: Bool?
    
    private var nameCancellable: AnyCancellable?
    private var ageCancellable: AnyCancellable?
    private var imageDataCancellable: AnyCancellable?
    private var isOwnCancellable: AnyCancellable?
    
    init(dataC: DataC) {
        self.dataC = dataC
        name = dataC.name
        age = dataC.age
        imageData = dataC.accountImage
        isOwn = dataC.isOwn
        
        imageDataCancellable = dataC.$accountImage.sink { [weak self] value in
            self?.imageData = value
        }
        nameCancellable = dataC.$name.sink { [weak self] value in
            self?.name = value
        }
        ageCancellable = dataC.$age.sink { [weak self] value in
            self?.age = value
        }
        
        isOwnCancellable = dataC.$isOwn.sink { [weak self] value in
            self?.isOwn = value
        }
    }
    
    func delete() {
        dataC.name = ""
        dataC.age = ""
        dataC.accountImage = nil
        dataC.isOwn = nil
        dataC.deleteAccount()
    }
}
