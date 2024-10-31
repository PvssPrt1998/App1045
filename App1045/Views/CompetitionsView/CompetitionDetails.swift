import SwiftUI
import Combine

struct CompetitionDetails: View {
    
    @ObservedObject var viewModel: CompetitionDetailsViewModel
    @Binding var show: Bool
    @State var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.c606067.opacity(0.3))
                        .frame(width: 36, height: 5)
                        .padding(.top, 5)
                    header
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            Text(viewModel.competition.name)
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            dateAndLocation
                                .padding(.top, 15)
                            description
                                .padding(.top, 15)
                            Text("My program")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 35)
                            programs
                                .padding(.top, 15)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
                
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private var header: some View {
        ZStack {
            Text("Competitions")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 15)
            HStack {
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
                Spacer()
                HStack(spacing: 16) {
                    NavigationLink {
                        EditCompetitionView(viewModel: ViewModelFactory.shared.makeEditCompetitionViewModel(viewModel.competition))
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.cSecondary)
                    }
                    Button {
                        withAnimation {
                            showDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 22)
                            .foregroundColor(.cSecondary)
                        .padding(.trailing, 16)
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("Delete"), message: Text("Are you sure you want to delete?"), primaryButton: .default(Text("Delete"), action: {
                            viewModel.delete()
                            show = false
                        }), secondaryButton: .destructive(Text("Close")))
                    }
                }
            }
        }
    }
    private var dateAndLocation: some View {
        HStack(spacing: 8) {
            VStack(spacing: 5) {
                Text(dateByComponents(viewModel.competition.date))
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Date")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c147151159)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
            .background(Color.cPrimary)
            .clipShape(.rect(cornerRadius: 10))
            VStack(spacing: 5) {
                Text(viewModel.competition.location)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Location")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c147151159)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
            .background(Color.cPrimary)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
    private var description: some View {
        VStack(spacing: 10) {
            Text("Description")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.competition.description)
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
    }
    private var programs: some View {
        LazyVStack(spacing: 15) {
            ForEach(viewModel.competition.programs, id: \.self) { program in
                programCard(program)
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
    
    func dateByComponents(_ dateStr: String) -> String {
        let str = dateStr.components(separatedBy: ".")
        var month = ""
        switch str[1] {
        case "01": month = "Jan"
        case "02": month = "Feb"
        case "03": month = "Mar"
        case "04": month = "Apr"
        case "05": month = "May"
        case "06": month = "Jun"
        case "07": month = "Jul"
        case "08": month = "Aug"
        case "09": month = "Sep"
        case "10": month = "Oct"
        case "11": month = "Nov"
        case "12": month = "Dec"
        default: {}()
        }
        return month + " " + str[0] + " " + str[2]
    }
}

struct CompetitionDetails_Preview: PreviewProvider {

    @State static var show = true
    
    static var previews: some View {
        CompetitionDetails(viewModel: ViewModelFactory.shared.makeCompetitionDetailsViewModel(Competition(uuid: UUID(), name: "Name", date: "05.05.2024", location: "Location", description: "Description", programs: [Program(puuid: UUID(), uuid: UUID(), name: "Name1", description: "Description1")])), show: $show)
    }
}

final class CompetitionDetailsViewModel: ObservableObject {
    
    let dataC: DataC
    var competition: Competition
    
    var competitionsCancellable: AnyCancellable?
    
    init(dataC: DataC, competition: Competition) {
        self.dataC = dataC
        self.competition = competition
        
        competitionsCancellable = dataC.$competitions.sink { [weak self] value in
            guard let index = value.firstIndex(where: {$0.uuid == competition.uuid}) else { return }
            self?.competition = value[index]
            self?.objectWillChange.send()
        }
    }
    
    func delete() {
        dataC.deleteCompetition(competition)
    }
}
