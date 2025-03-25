import Foundation


protocol StockProtocol {
    
    /// Identifiant unique du stock
    var id: String { get }
    
    /// Liste des identifiants des jeux disponibles en stock
    var gamesId: [String] { get }
    
    /// Identifiant du vendeur possédant ce stock
    var sellerId: String { get }
    
    /// Liste des identifiants des jeux déjà vendus
    var gamesSold: [String] { get }
}

class Stock: StockProtocol, ObservableObject, Codable, Identifiable {
    var id: String
    var gamesId: [String]  // Correction ici : tableau de chaînes de caractères
    var sellerId: String
    var gamesSold: [String]  // Correction ici : tableau de chaînes de caractères
    
    // Mapping des clés JSON si besoin
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Si l'API utilise "_id", on le mappe à "id"
        case gamesId = "games_id"
        case sellerId = "seller_id"
        case gamesSold = "games_sold"

    }
    
    // Initialiseur personnalisé pour Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        gamesId = try container.decode([String].self, forKey: .gamesId)  // Correction ici
        sellerId = try container.decode(String.self, forKey: .sellerId)
        gamesSold = try container.decode([String].self, forKey: .gamesSold)  // Correction ici
    }
    
    // Initialiseur par défaut
    init(id: String = "", gamesId: [String] = [], sellerId: String = "", gamesSold: [String] = []) {
        self.id = id
        self.gamesId = gamesId
        self.sellerId = sellerId
        self.gamesSold = gamesSold
    }
}




