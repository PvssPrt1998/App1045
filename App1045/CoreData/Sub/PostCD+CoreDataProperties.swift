import Foundation
import CoreData


extension PostCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostCD> {
        return NSFetchRequest<PostCD>(entityName: "PostCD")
    }

    @NSManaged public var name: String
    @NSManaged public var descr: String
    @NSManaged public var date: String
    @NSManaged public var uuid: UUID

}

extension PostCD : Identifiable {

}
