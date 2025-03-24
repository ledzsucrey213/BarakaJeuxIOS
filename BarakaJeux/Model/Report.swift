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
        eventId = try container.decode(String.self, forKey: .eventId)
        stockId = try container.decode(String.self, forKey: .stockId)
        
        // Récupération de la date sous forme de String
        let dateString = try container.decode(String.self, forKey: .reportDate)

        // Configurer le formateur pour supporter plusieurs formats
        let formatterWithFractional = ISO8601DateFormatter()
        formatterWithFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let formatterWithoutFractional = ISO8601DateFormatter()
        formatterWithoutFractional.formatOptions = [.withInternetDateTime]

        // Essayer d'abord avec fractions de secondes, sinon sans
        if let parsedDate = formatterWithFractional.date(from: dateString) ?? formatterWithoutFractional.date(from: dateString) {
            reportDate = parsedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .reportDate, in: container, debugDescription: "Format de date invalide : \(dateString)")
        }


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

