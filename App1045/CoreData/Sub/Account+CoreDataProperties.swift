
import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var name: String
    @NSManaged public var age: String
    @NSManaged public var image: Data

}

extension Account : Identifiable {

}
