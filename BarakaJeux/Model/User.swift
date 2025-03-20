import Foundation

enum UserRole: String, Codable, CaseIterable {
    case seller, buyer, admin, manager
}

class User: ObservableObject, Identifiable, Codable {
    var id: String?  // Propriété id pour respecter Identifiable
    var firstname: String
    var name: String
    var email: String
    var address: String?
    var role: UserRole
    var password: String?
    
    // Utilisation de CodingKeys pour faire correspondre la clé "_id" dans le JSON à la propriété "id" du modèle
    enum CodingKeys: String, CodingKey {
        case id = "_id"    // Mappage de "_id" vers "id"
        case firstname
        case name
        case email
        case address
        case role
        case password
    }
    
    // Initialiseur personnalisé pour Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Décodage des propriétés
        id = try container.decode(String.self, forKey: .id)
        firstname = try container.decode(String.self, forKey: .firstname)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        role = try container.decode(UserRole.self, forKey: .role)
        password = try container.decodeIfPresent(String.self, forKey: .password)
    }
    
    // Initialiseur par défaut
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

