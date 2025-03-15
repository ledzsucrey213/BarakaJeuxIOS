import Foundation

struct Report: Identifiable, Codable {
    var id: String
    var sellerId: String
    var totalEarned: Double
    var totalDue: Double
    var reportDate: Date
    var eventId: String
    var stockId: String
    
    init(id: String = "", sellerId: String = "", totalEarned: Double = 0, totalDue: Double = 0, reportDate: Date = Date(), eventId: String = "", stockId: String = "") {
        self.id = id
        self.sellerId = sellerId
        self.totalEarned = totalEarned
        self.totalDue = totalDue
        self.reportDate = reportDate
        self.eventId = eventId
        self.stockId = stockId
    }
}

