import Foundation

enum GameCondition: String, Codable {
    case new, veryGood = "very good", good, poor
}

class GameLabel: Identifiable, ObservableObject, Decodable, Encodable {
    var id: String?
    var sellerId: String
    var gameId: String
    var price: Double
    var eventId: String
    var condition: GameCondition
    var isSold: Bool
    var creation: Date
    var isOnSale: Bool
    
    // Mapping des clés JSON si nécessaire
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Mapping si l'API utilise "_id" pour l'ID
        case sellerId = "seller_id"
        case gameId = "game_id"
        case price
        case eventId = "event_id"
        case condition
        case isSold = "is_Sold"
        case creation
        case isOnSale = "is_On_Sale"
    }
    
    // Initialiseur personnalisé pour Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        sellerId = try container.decode(String.self, forKey: .sellerId)
        gameId = try container.decode(String.self, forKey: .gameId)
        price = try container.decode(Double.self, forKey: .price)
        eventId = try container.decode(String.self, forKey: .eventId)
        condition = try container.decode(GameCondition.self, forKey: .condition)
        isSold = try container.decode(Bool.self, forKey: .isSold)
        
        // Gérer la conversion de la chaîne en Date pour "creation"
        let creationString = try container.decode(String.self, forKey: .creation)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Format ISO 8601
        if let creationDate = dateFormatter.date(from: creationString) {
            creation = creationDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .creation, in: container, debugDescription: "Date format is invalid")
        }
        
        isOnSale = try container.decode(Bool.self, forKey: .isOnSale)
    }
    
    // Initialiseur par défaut
    init(id: String = "", sellerId: String = "", gameId: String = "", price: Double = 0, eventId: String = "", condition: GameCondition = .new, isSold: Bool = false, creation: Date = Date(), isOnSale: Bool = true) {
        self.id = id
        self.sellerId = sellerId
        self.gameId = gameId
        self.price = price
        self.eventId = eventId
        self.condition = condition
        self.isSold = isSold
        self.creation = creation
        self.isOnSale = isOnSale
    }
}

