import SwiftUI

struct CustomTF: View {
    
    @Binding var text: String
    
    var needPrefix: Bool = true
    let prefix: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 10) {
            if needPrefix {
                Text(prefix)
                    .font(.body.weight(.medium))
                    .foregroundColor(.white)
            }
            TextField("", text: $text)
                .font(.body.weight(.regular))
                .foregroundColor(.white)
                .autocorrectionDisabled(true)
                .accentColor(.white)
                .background(
                    placeholderView()
                )
        }
        .padding(.leading, 15)
        .frame(height: 44)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.c224231237, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder func placeholderView() -> some View {
        Text(text != "" ? "" : placeholder)
            .font(.body.weight(.regular))
            .foregroundColor(.white.opacity(0.4))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CustomTF_Preview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        CustomTF(text: $text, prefix: "Name", placeholder: "Name")
            .padding()
            .background(Color.bgMain)
    }
}
