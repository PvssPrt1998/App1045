import SwiftUI

struct Splash: View {
    
    @State var value: Double = 0
    @Binding var showSplash: Bool
    let dataC: DataC
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 144) {
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 43)
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .frame(width: 30, height: 30)
                        .scaleEffect(1.5, anchor: .center)
                    Text("\(Int(value * 100))%")
                        .font(.body.weight(.regular))
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            stroke()
            dataC.load()
        }
    }
    
    private func stroke() {
        if value < 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                self.value += 0.02
                self.stroke()
            }
        } else {
            if !dataC.loaded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                    self.stroke()
                }
            } else {
                showSplash = false
            }
        }
    }
}

struct Splash_Preview: PreviewProvider {
    
    @State static var showSplash = true
    
    static var previews: some View {
        Splash(showSplash: $showSplash, dataC: DataC())
    }
}
