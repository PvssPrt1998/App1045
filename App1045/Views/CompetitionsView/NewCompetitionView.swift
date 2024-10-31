import SwiftUI

struct NewCompetitionView: View {
    
    @ObservedObject var viewModel = ViewModelFactory.shared.makeNewCompetitionViewModel()
    
    @Binding var show: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.c606067.opacity(0.3))
                        .frame(width: 36, height: 5)
                        .padding(.top, 5)
                    ZStack {
                        Text("New competitions")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                        Button {
                            show = false
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
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            name
                            date
                            location
                            description
                            myProgramHeader
                            if viewModel.programs.isEmpty {
                                Text("Add the tricks that you will do in\nthe competition")
                                    .font(.subheadline.weight(.regular))
                                    .foregroundColor(.white.opacity(0.3))
                                    .multilineTextAlignment(.center)
                                    .padding(EdgeInsets(top: 63, leading: 0, bottom: 28, trailing: 0))
                            } else {
                                LazyVStack(spacing: 15) {
                                    ForEach(viewModel.programs, id: \.self) { program in
                                        programCard(program)
                                    }
                                }
                            }
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
                        .padding(EdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private var name: some View {
        VStack(spacing: 9) {
            Text("Name")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.name, needPrefix: false, prefix: "prefix", placeholder: "Enter name competition")
        }
    }
    
    private var date: some View {
        HStack(spacing: 15) {
            Text("Date")
                .font(.body.weight(.medium))
                .foregroundColor(.white)
            DatePicker("", selection: $viewModel.date, displayedComponents: .date)
                .accentColor(.white)
                .labelsHidden()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var location: some View {
        VStack(spacing: 9) {
            Text("Location")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.location, needPrefix: false, prefix: "prefix", placeholder: "Enter location")
        }
    }
    
    private var description: some View {
        VStack(spacing: 9) {
            Text("Description")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            AddTextField(text: $viewModel.description, needPrefix: false, prefix: "prefix", placeholder: "Enter description")
        }
    }
    
    private var myProgramHeader: some View {
        HStack(spacing: 0) {
            Text("My program")
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            NavigationLink {
                AddProgramView(name: $viewModel.programName, description: $viewModel.programDescription) {
                    viewModel.addProgramPressed()
                }
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    private func programCard(_ program: Program) -> some View {
        VStack(spacing: 10) {
            Text(program.name)
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(program.description)
                .font(.body.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(EdgeInsets(top: 15, leading: 16, bottom: 15, trailing: 16))
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct NewCompetitionView_Preview: PreviewProvider {
    
    @State static var income = ""
    @State static var show = true
    
    static var previews: some View {
        NewCompetitionView(show: $show)
    }
}

final class NewCompetitionViewModel: ObservableObject {
    
    let uuid = UUID()
    let dataC: DataC
    @Published var name = ""
    @Published var location = ""
    @Published var description = ""
    var disabled: Bool {
        name == "" || location == "" || description == ""
    }
    
    @Published var programName = ""
    @Published var programDescription = ""
    
    @Published var programs: Array<Program> = []
    
    @Published var date: Date = Date()
    
    init(dataC: DataC) {
        self.dataC = dataC
    }
    
    func addPressed() {
        let competition = Competition(uuid: uuid, name: name, date: dateToString(date), location: location, description: description, programs: programs)
        dataC.addCompetition(competition)
    }
    
    func addProgramPressed() {
        let program = Program(puuid: UUID(), uuid: uuid, name: programName, description: programDescription)
        programs.append(program)
        programName = ""
        programDescription = ""
    }
    
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
