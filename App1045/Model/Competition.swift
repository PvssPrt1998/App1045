import Foundation

struct Competition: Hashable {
    var uuid: UUID
    var name: String
    var date: String
    var location: String
    var description: String
    var programs: Array<Program> = []
}

struct Program: Hashable {
    var puuid: UUID
    var uuid: UUID
    var name: String
    var description: String
}
