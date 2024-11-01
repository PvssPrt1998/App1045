import Foundation
import SwiftUI

final class ViewModelFactory {
    
    let dataC: DataC = DataC()
    
    static let shared = ViewModelFactory()
    
    private init() {}
    
    func makeCreateAcccountViewModel() -> CreateAccountViewModel {
        CreateAccountViewModel(dContr: dataC)
    }
    
    func makeCompetitionsViewModel() -> CompetitionsViewModel {
        CompetitionsViewModel(dataC: dataC)
    }
    
    func makeEditIncomeViewModel() -> EditIncomeViewModel {
        EditIncomeViewModel(dataC: dataC)
    }
    func makeEditAffiliationViewModel() -> EditAffiliationViewModel {
        EditAffiliationViewModel(dataC: dataC)
    }
    func makeNewCompetitionViewModel() -> NewCompetitionViewModel {
        NewCompetitionViewModel(dataC: dataC)
    }
    func makeCompetitionDetailsViewModel(_ competition: Competition) -> CompetitionDetailsViewModel {
        CompetitionDetailsViewModel(dataC: dataC, competition: competition)
    }
    func makeEditCompetitionViewModel(_ competition: Competition) -> EditCompetitionViewModel {
        EditCompetitionViewModel(dataC: dataC, competition: competition)
    }
    func makeTricksViewModel() -> TricksViewModel {
        TricksViewModel(dataC: dataC)
    }
    func makeNewTrickViewModel() -> NewTrickViewModel {
        NewTrickViewModel(dataC: dataC)
    }
    func makeTrickDetailViewModel(_ trick: Trick) -> TrickDetailViewModel {
        TrickDetailViewModel(dataC: dataC, trick: trick)
    }
    func makeEditTrickViewModel(_ trick: Trick) -> EditTrickViewModel {
        EditTrickViewModel(dataC: dataC, trick: trick)
    }
    func makePlacesViewModel() -> PlacesViewModel {
        PlacesViewModel(dataC: dataC)
    }
    func makeAddPlaceViewModel() -> AddPlaceViewModel {
        AddPlaceViewModel(dataC: dataC)
    }
    func makePostsViewModel() -> PostsViewModel {
        PostsViewModel(dataC: dataC)
    }
    func makeNewPostViewModel() -> NewPostViewModel {
        NewPostViewModel(dataC: dataC)
    }
    func makePostDetailViewModel(_ post: Post) -> PostDetailViewModel {
        PostDetailViewModel(dataC: dataC, post: post)
    }
    func makeEditPostViewModel(_ post: Post) -> EditPostViewModel {
        EditPostViewModel(dataC: dataC, post: post)
    }
    func settingsViewModel() -> SettingsViewModel {
        SettingsViewModel(dataC: dataC)
    }
    func makeEditProfileViewModel() -> EditProfileViewModel {
        EditProfileViewModel(dataC: dataC)
    }
}
