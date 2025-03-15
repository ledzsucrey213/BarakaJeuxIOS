import Foundation

enum GameCondition: String, Codable {
    case new, veryGood = "very good", good, poor
}

struct GameLabel: Identifiable, Codable {
    var id: String
    var sellerId: String
    var gameId: String
    var price: Double
    var eventId: String
    var condition: GameCondition
    var isSold: Bool
    var creation: Date
    var isOnSale: Bool
    
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

