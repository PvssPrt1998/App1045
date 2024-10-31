import SwiftUI

struct EditPost: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: EditPostViewModel
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.c606067.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                ZStack {
                    Text("Edit")
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
                VStack(spacing: 15) {
                    name
                    HStack(spacing: 15) {
                        Text("Date")
                            .font(.body.weight(.medium))
                            .foregroundColor(.white)
                        DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                            .accentColor(.white)
                            .labelsHidden()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    description
                    Button {
                        viewModel.savePressed()
                        self.presentationMode.wrappedValue.dismiss()
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
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    private var name: some View {
        VStack(spacing: 9) {
            Text("Name")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.name, needPrefix: false, prefix: "prefix", placeholder: "Enter post name")
        }
    }
    
    private var description: some View {
        VStack(spacing: 9) {
            Text("Description")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.description, needPrefix: false, prefix: "prefix", placeholder: "Enter post description")
        }
    }
}

struct EditPost_Preview: PreviewProvider {
    
    static var previews: some View {
        EditPost(viewModel: ViewModelFactory.shared.makeEditPostViewModel(Post(uuid: UUID(), name: "name", date: "01.02.2012", description: "description")))
    }
}

final class EditPostViewModel: ObservableObject {
    
    let dataC: DataC
    
    var disabled: Bool {
        name == "" || description == ""
    }
    
    let uuid: UUID
    
    @Published var name: String
    @Published var date: Date = Date()
    @Published var description: String
    
    init(dataC: DataC, post: Post) {
        self.dataC = dataC
        uuid = post.uuid
        name = post.name
        description = post.description
        date = stringToDate(post.date) ?? Date()
    }
    
    private func stringToDate(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: str)
        if let date = date {
            return date
        } else { return nil }
    }
    
    func savePressed() {
        dataC.editPost(Post(uuid: uuid, name: name, date: dateToString(date), description: description))
    }
    
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
