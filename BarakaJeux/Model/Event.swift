import Foundation

struct Event: Identifiable, Codable {
    var id: String
    var name: String
    var start: Date
    var end: Date
    var isActive: Bool
    var commission: Double
    var depositFee: Double
    
    init(id: String = "", name: String = "", start: Date = Date(), end: Date = Date(), isActive: Bool = false, commission: Double = 0, depositFee: Double = 0) {
        self.id = id
        self.name = name
        self.start = start
        self.end = end
        self.isActive = isActive
        self.commission = commission
        self.depositFee = depositFee
    }
}

