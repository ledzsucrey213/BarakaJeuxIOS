import Foundation

struct Stock: Identifiable, Codable {
    var id: String
    var gamesId: [GameLabel]
    var sellerId: String
    var gamesSold: [GameLabel]
    
    init(id: String = "", gamesId: [GameLabel] = [], sellerId: String = "", gamesSold: [GameLabel] = []) {
        self.id = id
        self.gamesId = gamesId
        self.sellerId = sellerId
        self.gamesSold = gamesSold
    }
}

