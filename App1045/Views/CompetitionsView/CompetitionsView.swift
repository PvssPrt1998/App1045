import SwiftUI

struct CompetitionsView: View {
    
    @ObservedObject var viewModel = ViewModelFactory.shared.makeCompetitionsViewModel()
    
    @State var showEditIncomeSheet = false
    @State var showEditAffiliateSheet = false
    @State var showNewCompetitionSheet = false
    @State var showCompetitionDetail = false
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 0) {
                header
                stat
                    .padding(.top, 22)
                if viewModel.competitions.isEmpty {
                    emptyCompetitions
                        .padding(.top, 114)
                } else {
                    competitions
                        .padding(.top, 27)
                }
                
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .sheet(isPresented: $showEditIncomeSheet, content: {
            EditIncomeView(show: $showEditIncomeSheet)
        })
        .sheet(isPresented: $showEditAffiliateSheet, content: {
            EditAffiliationView(show: $showEditAffiliateSheet)
        })
        .sheet(isPresented: $showNewCompetitionSheet, content: {
            NewCompetitionView(show: $showNewCompetitionSheet)
        })
        .sheet(isPresented: $showCompetitionDetail, content: {
            CompetitionDetails(viewModel: ViewModelFactory.shared.makeCompetitionDetailsViewModel(viewModel.competition!), show: $showCompetitionDetail)
        })
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("Competitions")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 8, trailing: 0))
                .frame(maxWidth: .infinity, alignment: .leading)
            if !viewModel.competitions.isEmpty {
                Button {
                    showNewCompetitionSheet = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    private var stat: some View {
        HStack(spacing: 8) {
            income
            affilateProgram
        }
    }
    
    private var income: some View {
        VStack(spacing: 13) {
            Text("$\(viewModel.income)")
                .font(.largeTitle.bold())
                .foregroundColor(.cSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                Text("Income")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c147151159)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    showEditIncomeSheet = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .background(Color.cPrimary)
        .clipShape(.rect(cornerRadius: 10))
    }
    private var affilateProgram: some View {
        VStack(spacing: 13) {
            Text("$\(viewModel.affiliateProgram)")
                .font(.largeTitle.bold())
                .foregroundColor(.cSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                Text("Affiliate program")
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.c147151159)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    showEditAffiliateSheet = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .background(Color.cPrimary)
        .clipShape(.rect(cornerRadius: 10))
    }
    private var emptyCompetitions: some View {
        VStack(spacing: 5) {
            Text("Create new competition")
                .font(.title.bold())
                .foregroundColor(.white)
            Text("Your competitions will be\ndisplayed here")
                .font(.subheadline.weight(.regular))
                .foregroundColor(.white.opacity(0.3))
                .multilineTextAlignment(.center)
            Button {
                showNewCompetitionSheet = true
            } label: {
                Text("Click to create")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 228, height: 40)
                    .background(Color.cPrimary)
                    .clipShape(.rect(cornerRadius: 12))
            }
        }
    }
    
    private var competitions: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.competitions, id: \.self) { competition in
                    competitionCard(competition)
                        .onTapGesture {
                            viewModel.competition = competition
                            showCompetitionDetail = true
                        }
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    private func competitionCard(_ competition: Competition) -> some View {
        HStack(spacing: 10) {
            VStack(spacing: 0) {
                Text(competition.name + " | " + competition.location)
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(competition.description)
                    .font(.footnote.weight(.regular))
                    .foregroundColor(.c147151159)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 1, height: 99)
            
            VStack(spacing: 10) {
                Text(dateByComponents(competition.date).1)
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.white)
                Text(dateByComponents(competition.date).0)
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.white)
                Text(dateByComponents(competition.date).2)
                    .font(.subheadline.weight(.regular))
                    .foregroundColor(.white)
            }
        }
        .frame(height: 119)
        .padding(10)
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
    
    func dateByComponents(_ dateStr: String) -> (String, String, String) {
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
        return (str[0],month,str[2])
    }
}

#Preview {
    CompetitionsView()
}
