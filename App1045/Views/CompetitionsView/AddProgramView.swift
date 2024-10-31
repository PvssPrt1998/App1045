import SwiftUI

struct AddProgramView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var name: String
    @Binding var description: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.c606067.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                ZStack {
                    Text("Add program")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
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
                }
                Divider()
                VStack(spacing: 20) {
                    VStack(spacing: 9) {
                        Text("Name")
                            .font(.subheadline.weight(.regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        AddTextField(text: $name, needPrefix: false, prefix: "prefix", placeholder: "Enter name program")
                    }
                    VStack(spacing: 9) {
                        Text("Description")
                            .font(.subheadline.weight(.regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        AddTextField(text: $description, needPrefix: false, prefix: "prefix", placeholder: "Enter description")
                    }
                    Button {
                        action()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Add")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(height: 40)
                            .background(Color.cPrimary)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    .disabled(name == "" || description == "")
                    .opacity(name == "" || description == "" ? 0.6 : 1)
                }
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct AddProgramView_Preview: PreviewProvider {
    
    @State static var name = ""
    @State static var description = ""
    
    static var previews: some View {
        AddProgramView(name: $name, description: $description) {
            
        }
    }
}
