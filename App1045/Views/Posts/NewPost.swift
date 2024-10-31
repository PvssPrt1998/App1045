import SwiftUI

struct NewPost: View {
    @Binding var show: Bool
    @ObservedObject var viewModel = ViewModelFactory.shared.makeNewPostViewModel()
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.c606067.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 5)
                ZStack {
                    Text("New places skiing")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
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
                        viewModel.addPressed()
                        show = false
                    } label: {
                        Text("Add")
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

struct NewPost_Preview: PreviewProvider {
    
    @State static var show: Bool = true
    
    static var previews: some View {
        NewPost(show: $show)
    }
}

final class NewPostViewModel: ObservableObject {
    
    let dataC: DataC
    
    var disabled: Bool {
        name == "" || description == ""
    }
    
    @Published var name: String = ""
    @Published var date = Date()
    @Published var description = ""
    
    init(dataC: DataC) {
        self.dataC = dataC
    }
    
    func addPressed() {
        dataC.addPost(Post(uuid: UUID(), name: name, date: dateToString(date), description: description))
    }
    
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
