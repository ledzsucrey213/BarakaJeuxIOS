import Foundation

enum UserRole: String, Codable, CaseIterable {
    case seller, buyer, admin, manager
}


protocol UserProtocol {
    
    /// Identifiant unique de l'utilisateur (optionnel)
    var id: String? { get }
    
    /// Prénom de l'utilisateur
    var firstname: String { get }
    
    /// Nom de famille de l'utilisateur
    var name: String { get }
    
    /// Adresse e-mail de l'utilisateur
    var email: String { get }
    
    /// Adresse postale de l'utilisateur
    var address: String { get }
    
    /// Rôle de l'utilisateur (vendeur, acheteur, administrateur, etc.)
    var role: UserRole { get }
    
    /// Mot de passe (optionnel)
    var password: String? { get }
}


class User: UserProtocol, ObservableObject, Identifiable, Codable {
    var id: String?  // Propriété id pour respecter Identifiable
    var firstname: String
    var name: String
    var email: String
    var address: String
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
        address = try container.decode(String.self, forKey: .address)
        role = try container.decode(UserRole.self, forKey: .role)
        password = try container.decodeIfPresent(String.self, forKey: .password)
    }
    
    // Initialiseur par défaut
    init(id: String = "", firstname: String = "", name: String = "", email: String = "", address: String = "", role: UserRole = .buyer, password: String? = nil) {
        self.id = id
        self.firstname = firstname
        self.name = name
        self.email = email
        self.address = address
        self.role = role
        self.password = password
    }
}


// Structure UserToSubmit pour envoyer au backend
    struct UserToSubmit: Codable {
        var firstname: String
        var name: String
        var email: String
        var address: String?
        var role: UserRole
        
    }
