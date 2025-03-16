import Foundation

class Sale: ObservableObject, Decodable, Identifiable {
    var id: String
    var gameId: String  // gameId est maintenant une chaîne de caractères
    var quantitySold: Int
    var dateOfSale: String
    
    // Mapping des clés JSON si besoin
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Si l'API utilise "_id", on le mappe à "id"
        case gameId
        case quantitySold
        case dateOfSale
    }
    
    // Initialiseur personnalisé pour Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        gameId = try container.decode(String.self, forKey: .gameId)  // Correction ici
        quantitySold = try container.decode(Int.self, forKey: .quantitySold)
        dateOfSale = try container.decode(String.self, forKey: .dateOfSale)
    }
    
    // Initialiseur par défaut
    init(id: String = "", gameId: String = "", quantitySold: Int = 0, dateOfSale: String = "") {
        self.id = id
        self.gameId = gameId
        self.quantitySold = quantitySold
        self.dateOfSale = dateOfSale
    }
}

