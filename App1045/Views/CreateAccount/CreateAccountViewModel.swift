import Foundation

final class CreateAccountViewModel: ObservableObject {
    
    @Published var nameText = ""
    @Published var ageText = ""
    
    let dContr: DataC
    
    init(dContr: DataC) {
        self.dContr = dContr
    }
    
    func nextButtonPressed() {
        dContr.name = nameText
        dContr.age = ageText
    }
    
    func nextButtonPressedStage2(_ choice: Bool) {
        
    }
}
