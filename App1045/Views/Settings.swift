import SwiftUI
import StoreKit

struct Settings: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                
                VStack(spacing: 20) {
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
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
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
