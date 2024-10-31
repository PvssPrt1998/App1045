import Foundation
import CoreData


extension PlaceCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceCD> {
        return NSFetchRequest<PlaceCD>(entityName: "PlaceCD")
    }

    @NSManaged public var name: String
    @NSManaged public var rate: Int32
    @NSManaged public var available: Bool
    @NSManaged public var location: String

}

extension PlaceCD : Identifiable {

}
