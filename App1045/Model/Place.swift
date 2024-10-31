import Foundation

struct Place: Hashable {
    var name: String
    var available: Bool
    var rate: Int
    var location: String
}

struct Post: Hashable {
    var uuid: UUID
    var name: String
    var date: String
    var description: String
}
