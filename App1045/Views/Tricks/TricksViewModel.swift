import Foundation
import Combine

final class TricksViewModel: ObservableObject {
    
    let dataC: DataC
    
    @Published var tricks: Array<Trick>
    
    var trickForShow: Trick?
    
    private var tricksCancellable: AnyCancellable?
    
    init(dataC: DataC) {
        self.dataC = dataC
        
        self.tricks = dataC.tricks
        
        tricksCancellable = dataC.$tricks.sink { [weak self] value in
            self?.tricks = value
        }
        
    }
}
