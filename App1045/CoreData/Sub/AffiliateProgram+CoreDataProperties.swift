import Foundation
import CoreData


extension AffiliateProgram {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AffiliateProgram> {
        return NSFetchRequest<AffiliateProgram>(entityName: "AffiliateProgram")
    }

    @NSManaged public var value: Int32

}

extension AffiliateProgram : Identifiable {

}
