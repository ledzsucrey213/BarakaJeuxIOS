import Foundation

protocol GameLabelProtocol {
    
    /// Identifiant unique de l'étiquette
    var id: String? { get }
    
    /// Identifiant du vendeur de ce jeu
    var sellerId: String { get }
    
    /// Identifiant du jeu concerné
    var gameId: String { get }
    
    /// Prix du jeu
    var price: Double { get }
    
    /// Identifiant de l'événement associé
    var eventId: String { get }
    
    /// État du jeu (neuf, très bon état, bon état, mauvais état)
    var condition: GameCondition { get }
    
    /// Indique si le jeu a été vendu
    var isSold: Bool { get }
    
    /// Date de création de l'étiquette
    var creation: Date? { get }
    
    /// Indique si le jeu est en vente
    var isOnSale: Bool { get }
    
    /// Frais de dépôt du jeu (optionnel)
    var depositFee: Double? { get }
}


enum GameCondition: String, Codable {
    case new, veryGood = "very good", good, poor
}

class GameLabel: GameLabelProtocol, Identifiable, ObservableObject, Decodable, Encodable {
    var depositFee: Double?
    
    var id: String?
    var sellerId: String
    var gameId: String
    var price: Double
    var eventId: String
    var condition: GameCondition
    var isSold: Bool
    var creation: Date?
    var isOnSale: Bool
    var deposit_fee : Double?
    
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
        case deposit_fee
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
        deposit_fee = try container.decodeIfPresent(Double.self, forKey: .deposit_fee) ?? 0.0 // 👈 Valeur par défaut
        
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
    init(id: String = "", sellerId: String = "", gameId: String = "", price: Double = 0, eventId: String = "", condition: GameCondition = .new, isSold: Bool = false, creation: Date = Date(), isOnSale: Bool = true, deposit_fee : Double = 0) {
        self.id = id
        self.sellerId = sellerId
        self.gameId = gameId
        self.price = price
        self.eventId = eventId
        self.condition = condition
        self.isSold = isSold
        self.creation = creation
        self.isOnSale = isOnSale
        self.deposit_fee = deposit_fee
    }
    
    

    
    
}


// Structure GameLabelToSubmit pour envoyer au backend
    struct GameLabelToSubmit: Codable {
        var sellerId: String
        var gameId: String
        var price: Double
        var eventId: String
        var condition: GameCondition
        var isSold: Bool
        var isOnSale: Bool
        var depositFee: Double?
        
        enum CodingKeys: String, CodingKey {
            case sellerId = "seller_id"
            case gameId = "game_id"
            case price
            case eventId = "event_id"
            case condition
            case isSold = "is_Sold"
            case isOnSale = "is_On_Sale"
            case depositFee = "deposit_fee"
        }
    }

