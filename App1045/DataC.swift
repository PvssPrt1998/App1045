import Foundation

final class DataC: ObservableObject {
    
    let storageManager = StorageManager()
    
    @Published var isOwn: Bool?
    @Published var accountImage: Data?
    
    @Published var name: String = ""
    @Published var age: String = ""
    
    var loaded = false
    @Published var income = 0
    @Published var affiliateProgram = 0
    @Published var competitions: Array<Competition> = []
    @Published var tricks: Array<Trick> = []
    @Published var places: Array<Place> = []
    @Published var posts: Array<Post> = []
    
    func load() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            if let income = try? storageManager.fetchIncome() {
                self.income = income
            }
            if let affilate = try? storageManager.fetchAffiliateProgram() {
                self.affiliateProgram = affilate
                print(affilate)
            }
            if let competitions = try? storageManager.fetchCompetitions() {
                self.competitions = competitions
            }
            if let tricks = try? storageManager.fetchTrick() {
                self.tricks = tricks
            }
            if let places = try? storageManager.fetchPlaces() {
                self.places = places
            }
            if let posts = try? storageManager.fetchPost() {
                self.posts = posts
            }
            if let account = try? storageManager.fetchAccount() {
                self.name = account.0
                self.age = account.1
                self.accountImage = account.2
            }
            if let choice = try? storageManager.fetchChoice() {
                self.isOwn = choice
            }
            
            DispatchQueue.main.async {
                self.loaded = true
            }
        }
    }
    
    func saveAccount() {
        guard let imageData = accountImage else { return }
        storageManager.saveOrEditAccount(name: name, age: age, imageData: imageData)
    }
    
    func saveChoice() {
        guard let isOwn = isOwn else { return }
        storageManager.saveChoice(isOwn)
    }
    
    func saveIncome(_ income: Int) {
        self.income = income
        storageManager.saveIncome(income)
    }
    
    func saveAffiliate(_ affiliate: Int) {
        self.affiliateProgram = affiliate
        storageManager.saveAffiliateProgram(affiliate)
    }
    
    func addCompetition(_ competition: Competition) {
        competitions.append(competition)
        storageManager.saveCompetition(competition)
    }
    
    func deleteCompetition(_ competition: Competition) {
        guard let index = competitions.firstIndex(where: {$0.uuid == competition.uuid}) else { return }
        competitions.remove(at: index)
        try? storageManager.removeCompetition(competition)
    }
    
    func editCompetition(_ competition: Competition) {
        guard let index = competitions.firstIndex(where: {$0.uuid == competition.uuid}) else { return }
        competitions[index] = competition
        storageManager.editCompetition(competition)
    }
    
    func addTrick(_ trick: Trick) {
        tricks.append(trick)
        storageManager.saveTrick(trick)
    }
    
    func deleteTrick(_ trick: Trick) {
        guard let index = tricks.firstIndex(where: {$0.uuid == trick.uuid}) else { return }
        tricks.remove(at: index)
        try? storageManager.removeTrick(trick)
    }
    
    func editTrick(_ trick: Trick) {
        guard let index = tricks.firstIndex(where: {$0.uuid == trick.uuid}) else { return }
        tricks[index] = trick
        storageManager.editTrick(trick)
    }
    
    func addPlace(_ place: Place) {
        places.append(place)
        storageManager.savePlace(place)
    }
    
    func addPost(_ post: Post) {
        posts.append(post)
        storageManager.savePost(post)
    }
    
    func delete(_ post: Post) {
        guard let index = posts.firstIndex(where: {$0.uuid == post.uuid}) else { return }
        posts.remove(at: index)
        try? storageManager.removePost(post)
    }
    
    func editPost(_ post: Post) {
        guard let index = posts.firstIndex(where: {$0.uuid == post.uuid}) else { return }
        posts[index] = post
        storageManager.editPost(post)
    }
}
