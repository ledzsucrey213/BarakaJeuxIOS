import Foundation

class Event: Identifiable, Codable {
    var id: String?
    var name: String
    var start: Date
    var end: Date
    var isActive: Bool
    var commission: Double
    var depositFee: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case start
        case end
        case isActive = "is_active"
        case commission
        case depositFee = "deposit_fee"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try? container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        // ✅ Décodeur de date amélioré
        let startString = try container.decode(String.self, forKey: .start)
        let endString = try container.decode(String.self, forKey: .end)

        start = Event.decodeDate(from: startString) ?? Date()
        end = Event.decodeDate(from: endString) ?? Date()

        isActive = try container.decode(Bool.self, forKey: .isActive)
        commission = try container.decode(Double.self, forKey: .commission)
        depositFee = try container.decode(Double.self, forKey: .depositFee)
    }

    init(id: String? = nil, name: String = "", start: Date = Date(), end: Date = Date(), isActive: Bool = false, commission: Double = 0, depositFee: Double = 0) {
        self.id = id
        self.name = name
        self.start = start
        self.end = end
        self.isActive = isActive
        self.commission = commission
        self.depositFee = depositFee
    }

    // ✅ Fonction pour décoder plusieurs formats de date
    static func decodeDate(from dateString: String) -> Date? {
        let formatters = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ", // Format avec millisecondes
            "yyyy-MM-dd'T'HH:mm:ssZ"      // Format sans millisecondes
        ]

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        for format in formatters {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }

        print("⚠️ Impossible de décoder la date : \(dateString)")
        return nil
    }
}

