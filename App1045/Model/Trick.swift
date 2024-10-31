import Foundation

struct Trick: Hashable {
    
    let uuid: UUID
    var name: String
    var category: String
    var description: String
    var technic: String
    var complexity: Int
    var images: Array<TrickImage> = []
}

struct TrickImage: Hashable {
    let uuid: UUID
    let imageUUID: UUID
    var imageData: Data
}
