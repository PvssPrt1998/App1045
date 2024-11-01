

import Foundation
import CoreData


extension Choice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Choice> {
        return NSFetchRequest<Choice>(entityName: "Choice")
    }

    @NSManaged public var isOwn: Bool

}

extension Choice : Identifiable {

}
