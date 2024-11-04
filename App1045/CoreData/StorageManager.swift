import Foundation

final class StorageManager {
    private let modelName = "Storage"
    
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
    func saveIncome(_ value: Int) {
        do {
            let incomes = try coreDataStack.managedContext.fetch(Income.fetchRequest())
            if incomes.count > 0 {
                //exists
                incomes[0].value = Int32(value)
            } else {
                let income =  Income(context: coreDataStack.managedContext)
                income.value = Int32(value)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchIncome() throws -> Int? {
        guard let income = try coreDataStack.managedContext.fetch(Income.fetchRequest()).first else { return nil }
        return Int(income.value)
    }
    
    func saveAffiliateProgram(_ value: Int) {
        do {
            let affiliates = try coreDataStack.managedContext.fetch(AffiliateProgram.fetchRequest())
            if affiliates.count > 0 {
                //exists
                affiliates[0].value = Int32(value)
            } else {
                let affiliate =  AffiliateProgram(context: coreDataStack.managedContext)
                affiliate.value = Int32(value)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchAffiliateProgram() throws -> Int? {
        guard let affilate = try coreDataStack.managedContext.fetch(AffiliateProgram.fetchRequest()).first else { return nil }
        return Int(affilate.value)
    }
    
    func saveCompetition(_ competition: Competition) {
        let competitionCD = CompetitionCD(context: coreDataStack.managedContext)
        competitionCD.desr = competition.description
        competitionCD.name = competition.name
        competitionCD.uuid = competition.uuid
        competitionCD.date = competition.date
        competitionCD.location = competition.location
        competition.programs.forEach { program in
            let programCD = ProgramCD(context: coreDataStack.managedContext)
            programCD.uuid = program.uuid
            programCD.name = program.name
            programCD.descr = program.description
            programCD.puuid = program.puuid
        }
        coreDataStack.saveContext()
    }
    
    func removeCompetition(_ competition: Competition) throws {
        let competitions = try coreDataStack.managedContext.fetch(CompetitionCD.fetchRequest())
        let programs = try coreDataStack.managedContext.fetch(ProgramCD.fetchRequest())
        let competitionCD = competitions.first(where: {$0.uuid == competition.uuid})
        guard let competitionCD = competitionCD else { return }
        programs.forEach { programCD in
            if programCD.uuid == competition.uuid {
                coreDataStack.managedContext.delete(programCD)
            }
        }
        coreDataStack.managedContext.delete(competitionCD)
        coreDataStack.saveContext()
    }
    
    func fetchCompetitions() throws -> Array<Competition> {
        var array: Array<Competition> = []
        let programs = try coreDataStack.managedContext.fetch(ProgramCD.fetchRequest())
        let competitions = try coreDataStack.managedContext.fetch(CompetitionCD.fetchRequest())
        competitions.forEach { cCD in
            var sutablePrograms: Array<Program> = []
            programs.forEach { pCD in
                if pCD.uuid == cCD.uuid {
                    sutablePrograms.append(Program(puuid: pCD.puuid, uuid: pCD.uuid, name: pCD.name, description: pCD.descr))
                }
            }
            array.append(Competition(uuid: cCD.uuid, name: cCD.name, date: cCD.date, location: cCD.location, description: cCD.desr, programs: sutablePrograms))
        }
        return array
    }
    
    func editCompetition(_ competition: Competition) {
        do {
            let competitionsCD = try coreDataStack.managedContext.fetch(CompetitionCD.fetchRequest())
            let programsCD = try coreDataStack.managedContext.fetch(ProgramCD.fetchRequest())
            competitionsCD.forEach { competitionCD in
                if competitionCD.uuid == competition.uuid {
                    competitionCD.name = competition.name
                    competitionCD.location = competition.location
                    competitionCD.date = competition.date
                    competitionCD.desr = competition.description
                    
                    programsCD.forEach { programCD in
                        if competition.uuid == programCD.uuid {
                            coreDataStack.managedContext.delete(programCD)
                        }
                    }
                    competition.programs.forEach { program in
                        let programCD = ProgramCD(context: coreDataStack.managedContext)
                        programCD.uuid = program.uuid
                        programCD.name = program.name
                        programCD.descr = program.description
                        programCD.puuid = program.puuid
                    }
                    
                    coreDataStack.saveContext()
                    return
                }
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func saveTrick(_ trick: Trick) {
        let trickCD = TrickCD(context: coreDataStack.managedContext)
        trickCD.descr = trick.description
        trickCD.name = trick.name
        trickCD.uuid = trick.uuid
        trickCD.category = trick.category
        trickCD.complexity = Int32(trick.complexity)
        trickCD.technic = trick.technic
        trick.images.forEach { image in
            let imageCD = ImageData(context: coreDataStack.managedContext)
            imageCD.uuid = image.uuid
            imageCD.imageUUID = image.imageUUID
            imageCD.imageData = image.imageData
        }
        coreDataStack.saveContext()
    }
    
    func fetchTrick() throws -> Array<Trick> {
        var array: Array<Trick> = []
        let imagesCD = try coreDataStack.managedContext.fetch(ImageData.fetchRequest())
        let tricksCD = try coreDataStack.managedContext.fetch(TrickCD.fetchRequest())
        tricksCD.forEach { tCD in
            var sutableImages: Array<TrickImage> = []
            imagesCD.forEach { iCD in
                if iCD.uuid == tCD.uuid {
                    sutableImages.append(TrickImage(uuid: iCD.uuid, imageUUID: iCD.imageUUID, imageData: iCD.imageData))
                }
            }
            array.append(Trick(uuid: tCD.uuid, name: tCD.name, category: tCD.category, description: tCD.descr, technic: tCD.technic, complexity: Int(tCD.complexity), images: sutableImages))
        }
        return array
    }
    
    func removeTrick(_ trick: Trick) throws {
        let tricks = try coreDataStack.managedContext.fetch(TrickCD.fetchRequest())
        let images = try coreDataStack.managedContext.fetch(ImageData.fetchRequest())
        let trickCD = tricks.first(where: {$0.uuid == trick.uuid})
        guard let trickCD = trickCD else { return }
        images.forEach { imageCD in
            if imageCD.uuid == trickCD.uuid {
                coreDataStack.managedContext.delete(imageCD)
            }
        }
        coreDataStack.managedContext.delete(trickCD)
        coreDataStack.saveContext()
    }
    
    func editTrick(_ trick: Trick) {
        do {
            let tricksCD = try coreDataStack.managedContext.fetch(TrickCD.fetchRequest())
            let imagesCD = try coreDataStack.managedContext.fetch(ImageData.fetchRequest())
            tricksCD.forEach { tCD in
                if tCD.uuid == trick.uuid {
                    tCD.name = trick.name
                    tCD.technic = trick.technic
                    tCD.category = trick.category
                    tCD.complexity = Int32(trick.complexity)
                    tCD.descr = trick.description
                    
                    imagesCD.forEach { imageCD in
                        if imageCD.uuid == trick.uuid {
                            coreDataStack.managedContext.delete(imageCD)
                        }
                    }
                    trick.images.forEach { image in
                        let imageCD = ImageData(context: coreDataStack.managedContext)
                        imageCD.uuid = image.uuid
                        imageCD.imageUUID = image.imageUUID
                        imageCD.imageData = image.imageData
                    }
                    
                    coreDataStack.saveContext()
                    return
                }
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func savePlace(_ place: Place) {
        let placeCD = PlaceCD(context: coreDataStack.managedContext)
        placeCD.name = place.name
        placeCD.location = place.location
        placeCD.rate = Int32(place.rate)
        placeCD.available = place.available
        coreDataStack.saveContext()
    }
    
    func fetchPlaces() throws -> Array<Place> {
        var array: Array<Place> = []
        let placesCD = try coreDataStack.managedContext.fetch(PlaceCD.fetchRequest())
        placesCD.forEach { pCD in
            array.append(Place(name: pCD.name, available: pCD.available, rate: Int(pCD.rate), location: pCD.location))
        }
        return array
    }
    
    func savePost(_ post: Post) {
        let postCD = PostCD(context: coreDataStack.managedContext)
        postCD.uuid = post.uuid
        postCD.date = post.date
        postCD.name = post.name
        postCD.descr = post.description
        coreDataStack.saveContext()
    }
    
    func fetchPost() throws -> Array<Post> {
        var array: Array<Post> = []
        let postsCD = try coreDataStack.managedContext.fetch(PostCD.fetchRequest())
        postsCD.forEach { pCD in
            array.append(Post(uuid: pCD.uuid, name: pCD.name, date: pCD.date, description: pCD.descr))
        }
        return array
    }
    
    func editPost(_ post: Post) {
        do {
            let posts = try coreDataStack.managedContext.fetch(PostCD.fetchRequest())
            let postCD = posts.first(where: {$0.uuid == post.uuid})
            guard let postCD = postCD else { return }
            postCD.date = post.date
            postCD.name = post.name
            postCD.descr = post.description
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func removePost(_ post: Post) throws {
        let posts = try coreDataStack.managedContext.fetch(PostCD.fetchRequest())
        let postCD = posts.first(where: {$0.uuid == post.uuid})
        guard let postCD = postCD else { return }
        coreDataStack.managedContext.delete(postCD)
        coreDataStack.saveContext()
    }
    
    func saveOrEditAccount(name: String, age: String, imageData: Data) {
        do {
            let accounts = try coreDataStack.managedContext.fetch(Account.fetchRequest())
            if accounts.count > 0 {
                //exists
                accounts[0].name = name
                accounts[0].age = age
                accounts[0].image = imageData
            } else {
                let account =  Account(context: coreDataStack.managedContext)
                account.name = name
                account.age = age
                account.image = imageData
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchAccount() throws -> (String, String, Data)? {
        guard let account = try coreDataStack.managedContext.fetch(Account.fetchRequest()).first else { return nil }
        return (account.name, account.age, account.image)
    }
    
    func saveChoice(_ choice: Bool) {
        do {
            let choices = try coreDataStack.managedContext.fetch(Choice.fetchRequest())
            if choices.count > 0 {
                //exists
                choices[0].isOwn = choice
            } else {
                let choiceCD = Choice(context: coreDataStack.managedContext)
                choiceCD.isOwn = choice
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchChoice() throws -> Bool? {
        guard let choice = try coreDataStack.managedContext.fetch(Choice.fetchRequest()).first else { return nil }
        return choice.isOwn
    }
    
    func removeAccount() throws {
        let choices = try coreDataStack.managedContext.fetch(Choice.fetchRequest())
        if choices.count > 0 {
            coreDataStack.managedContext.delete(choices[0])
        }
        let accounts = try coreDataStack.managedContext.fetch(Account.fetchRequest())
        if accounts.count > 0 {
            coreDataStack.managedContext.delete(accounts[0])
        }
        
        coreDataStack.saveContext()
    }
}
