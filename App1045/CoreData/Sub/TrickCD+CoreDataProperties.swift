import Foundation
import CoreData


extension TrickCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrickCD> {
        return NSFetchRequest<TrickCD>(entityName: "TrickCD")
    }

    @NSManaged public var name: String
    @NSManaged public var complexity: Int32
    @NSManaged public var category: String
    @NSManaged public var descr: String
    @NSManaged public var technic: String
    @NSManaged public var uuid: UUID

}

extension TrickCD : Identifiable {

}
