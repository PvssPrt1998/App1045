import Foundation
import Combine

final class CompetitionsViewModel: ObservableObject {
    
    let dataC: DataC
    @Published var income: String
    @Published var affiliateProgram: String
    @Published var competitions: Array<Competition>
    
    private var incomeCancellable: AnyCancellable?
    private var affiliateCancellable: AnyCancellable?
    private var competitionCancellable: AnyCancellable?
    
    var competition: Competition?
    
    init(dataC: DataC) {
        self.dataC = dataC
        self.income = "\(dataC.income)"
        self.affiliateProgram = "\(dataC.affiliateProgram)"
        self.competitions = dataC.competitions
        
        incomeCancellable = dataC.$income.sink { [weak self] value in
            self?.income = "\(value)"
        }
        affiliateCancellable = dataC.$affiliateProgram.sink { [weak self] value in
            self?.affiliateProgram = "\(value)"
        }
        competitionCancellable = dataC.$competitions.sink { [weak self] value in
            self?.competitions = value
        }
    }
    
}
