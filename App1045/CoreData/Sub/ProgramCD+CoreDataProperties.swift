import Foundation
import CoreData


extension ProgramCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgramCD> {
        return NSFetchRequest<ProgramCD>(entityName: "ProgramCD")
    }

    @NSManaged public var puuid: UUID
    @NSManaged public var uuid: UUID
    @NSManaged public var name: String
    @NSManaged public var descr: String
}

extension ProgramCD : Identifiable {

}
