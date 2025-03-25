import Foundation


protocol GameProtocol {
    
    /// Identifiant unique du jeu (optionnel, car il peut être généré par une base de données)
    var id: String? { get }
    
    /// Nom du jeu
    var name: String { get }
    
    /// Nom de l'éditeur du jeu
    var editor: String { get }
    
    /// Description détaillée du jeu
    var description: String { get }
    
    /// Nombre d'exemplaires disponibles
    var count: Int { get }
}



class Game: GameProtocol, ObservableObject, Codable, Identifiable {
    var id: String?
    var name: String
    var editor: String
    var description: String
    var count: Int
    
    // Mapping des clés JSON si besoin
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Si l'API utilise "_id", on le mappe à "id"
        case name
        case editor
        case description
        case count
    }
    
    // Initialiseur personnalisé pour Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        editor = try container.decode(String.self, forKey: .editor)
        description = try container.decode(String.self, forKey: .description)
        count = try container.decode(Int.self, forKey: .count)
    }
    
    // Initialiseur par défaut
    init(id: String = "", name: String = "", editor: String = "", description: String = "", count: Int = 0) {
        self.id = id
        self.name = name
        self.editor = editor
        self.description = description
        self.count = count
    }
}


struct GameToSubmit: Codable {
    var name: String
    var editor: String
    var description: String
    var count: Int
    
}


