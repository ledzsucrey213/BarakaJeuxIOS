import Foundation

enum PaymentMethod: String, Codable {
    case card, cash
}

struct Sale: Identifiable, Codable {
    var id: String
    var totalPrice: Double
    var gamesId: [GameLabel]
    var saleDate: Date
    var totalCommission: Double
    var paidWith: PaymentMethod
    
    init(id: String = "", totalPrice: Double = 0, gamesId: [GameLabel] = [], saleDate: Date = Date(), totalCommission: Double = 0, paidWith: PaymentMethod = .card) {
        self.id = id
        self.totalPrice = totalPrice
        self.gamesId = gamesId
        self.saleDate = saleDate
        self.totalCommission = totalCommission
        self.paidWith = paidWith
    }
}

