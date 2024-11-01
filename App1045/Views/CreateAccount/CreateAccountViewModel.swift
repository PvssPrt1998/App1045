import Foundation

final class CreateAccountViewModel: ObservableObject {
    
    var diabled: Bool {
        nameText == "" || ageText == "" || imageData == nil
    }
    
    @Published var nameText: String
    @Published var ageText: String
    @Published var imageData: Data?
    
    let dContr: DataC
    
    init(dContr: DataC) {
        self.dContr = dContr
        
        nameText = dContr.name
        ageText = dContr.age
        imageData = dContr.accountImage
    }
    
    func nextButtonPressed() {
        dContr.name = nameText
        dContr.age = ageText
        dContr.accountImage = imageData
        dContr.saveAccount()
    }
    
    func nextButtonPressedStage2(_ choice: Bool) {
        dContr.isOwn = choice
        dContr.saveChoice()
    }
}
