import Foundation
import CoreData


extension CompetitionCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompetitionCD> {
        return NSFetchRequest<CompetitionCD>(entityName: "CompetitionCD")
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var name: String
    @NSManaged public var date: String
    @NSManaged public var location: String
    @NSManaged public var desr: String
}

extension CompetitionCD : Identifiable {

}
