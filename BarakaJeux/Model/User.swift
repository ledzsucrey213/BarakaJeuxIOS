import Foundation

enum UserRole: String, Codable {
    case seller, buyer, admin, manager
}

struct User: Identifiable, Codable {
    var id: String
    var firstname: String
    var name: String
    var email: String
    var address: String?
    var role: UserRole
    var password: String?
    
    init(id: String = "", firstname: String = "", name: String = "", email: String = "", address: String? = nil, role: UserRole = .buyer, password: String? = nil) {
        self.id = id
        self.firstname = firstname
        self.name = name
        self.email = email
        self.address = address
        self.role = role
        self.password = password
    }
}

