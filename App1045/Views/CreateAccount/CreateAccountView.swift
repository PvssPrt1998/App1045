import SwiftUI

struct CreateAccountView: View {
    
    @ObservedObject var viewModel: CreateAccountViewModel
    @State var stage1 = true
    @State var firstChoice: Bool?
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
            header
                .frame(maxHeight: .infinity, alignment: .top)
            VStack(spacing: 0) {
                fillData
                
            }
            
            Button {
                nextButtonPressed()
            } label: {
                Text("Next")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.cPrimary)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .disabled(buttonDisabled)
            .opacity(buttonDisabled ? 0.6 : 1)
            .padding(.horizontal, 15)
            .padding(.bottom, 8)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard)
        }
    }
    
    private var header: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.cSecondary)
                .frame(width: 8, height: 8)
                .opacity(stage1 ? 1 : 0.3)
            Circle()
                .fill(Color.cSecondary)
                .frame(width: 8, height: 8)
                .opacity(stage1 ? 0.3 : 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .overlay(
            Button {
                withAnimation {
                    show = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.cSecondary)
                    .clipShape(.circle)
            }
                .padding(.horizontal, 15)
            ,alignment: .trailing
        )
    }
    private var fillData: some View {
        VStack(spacing: 25) {
            text
            if stage1 {
                textFields
            }
        }
        .padding(.horizontal, 15)
        .frame(maxHeight: .infinity)
    }
    private var text: some View {
        VStack(spacing: 10) {
            Text("Let's create\nyour profile")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Text(stage1 ? "Specify your name and age category" : "Choose the skating category that suits your needs")
                .font(.body.weight(.regular))
                .foregroundColor(.c151151151)
                .multilineTextAlignment(.center)
            
            if !stage1 {
                choseViews
            }
        }
    }
    private var textFields: some View {
        VStack(spacing: 15) {
            ImageView(imageData: $viewModel.imageData)
            CustomTF(text: $viewModel.nameText, prefix: "Name", placeholder: "Enter")
            CustomTF(text: $viewModel.ageText, prefix: "Age category", placeholder: "Enter")
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
                    .stroke(firstChoice == true ? Color.cSecondary : .clear)
            )
            .onTapGesture {
                if firstChoice == true {
                    firstChoice = nil
                } else {
                    firstChoice = true
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
                    .stroke(firstChoice == false ? Color.cSecondary : .clear)
            )
            .onTapGesture {
                if firstChoice == false {
                    firstChoice = nil
                } else {
                    firstChoice = false
                }
            }
        }
    }
    
    private var buttonDisabled: Bool {
        if stage1 {
            if viewModel.nameText == "" || viewModel.ageText == "" || viewModel.imageData == nil {
                return true
            } else {
                return false
            }
        } else {
            if firstChoice == nil {
                return true
            } else { return false }
        }
    }
    
    private func nextButtonPressed() {
        if stage1 {
            viewModel.nextButtonPressed()
            withAnimation {
                stage1 = false
            }
        } else {
            viewModel.nextButtonPressedStage2(firstChoice!)
            withAnimation {
                show = false
            }
        }
    }
    
}

struct CreateAccountView_Preview: PreviewProvider {
    
    @State static var showCreateAccount = true
    
    static var previews: some View {
        CreateAccountView(viewModel: ViewModelFactory.shared.makeCreateAcccountViewModel(), show: $showCreateAccount)
    }
}
