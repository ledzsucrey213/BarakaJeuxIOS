import Foundation

class Report: ObservableObject, Identifiable, Codable {
    var id: String
    var sellerId: String
    var totalEarned: Double
    var totalDue: Double
    var reportDate: Date
    var eventId: String
    var stockId: String
    
    // Mapping des clés JSON si elles diffèrent du modèle Swift
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sellerId = "seller_id"
        case totalEarned = "total_earned"
        case totalDue = "total_due"
        case reportDate = "report_date"
        case eventId = "event_id"
        case stockId = "stock_id"
    }
    
    // Initialiseur pour la désérialisation JSON
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        sellerId = try container.decode(String.self, forKey: .sellerId)
        totalEarned = try container.decode(Double.self, forKey: .totalEarned)
        totalDue = try container.decode(Double.self, forKey: .totalDue)
        reportDate = try container.decode(Date.self, forKey: .reportDate)
        eventId = try container.decode(String.self, forKey: .eventId)
        stockId = try container.decode(String.self, forKey: .stockId)
    }
    
    // Initialiseur par défaut
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

