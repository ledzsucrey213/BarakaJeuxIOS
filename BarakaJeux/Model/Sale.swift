import Foundation


protocol SaleProtocol {
    
    /// Identifiant unique de la vente (optionnel)
    var id: String? { get }
    
    /// Prix total de la vente
    var totalPrice: Double { get }
    
    /// Liste des identifiants des jeux vendus
    var gamesId: [String] { get }
    
    /// Commission totale appliquée sur la vente
    var totalCommission: Double { get }
    
    /// Date de la vente
    var dateOfSale: Date { get }
    
    /// Moyen de paiement utilisé (carte ou espèces)
    var paidWith: Payment { get }
}

enum Payment: String, Codable {
    case card, cash
}

class Sale: SaleProtocol, ObservableObject, Codable, Identifiable {
    var id: String?
    var totalPrice: Double
    var gamesId: [String] // Liste des IDs des jeux vendus
    var totalCommission: Double
    var dateOfSale: Date
    var paidWith : Payment

    // Mapping des clés JSON
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case totalPrice = "total_price"
        case gamesId = "games_id"
        case totalCommission = "total_commission"
        case dateOfSale = "sale_date"
        case paidWith = "paid_with"
    }

    /// **Initialiseur pour `Decodable`**
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        totalPrice = try container.decode(Double.self, forKey: .totalPrice)
        gamesId = try container.decode([String].self, forKey: .gamesId)
        totalCommission = try container.decode(Double.self, forKey: .totalCommission)
        paidWith = try container.decode(Payment.self, forKey: .paidWith)

        // Configurer le formateur pour autoriser les fractions de secondes
        let dateString = try container.decode(String.self, forKey: .dateOfSale)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        
        // Tenter de décoder la date avec le format ISO8601
        if let parsedDate = formatter.date(from: dateString) {
            dateOfSale = parsedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dateOfSale, in: container, debugDescription: "Format de date invalide")
        }
    }


    /// **Initialiseur manuel**
    init(id: String = "", totalPrice: Double = 0.0, gamesId: [String] = [], totalCommission: Double = 0.0, dateOfSale: Date = Date(), paidWith: Payment = .cash) {
        self.id = id
        self.totalPrice = totalPrice
        self.gamesId = gamesId
        self.totalCommission = totalCommission
        self.dateOfSale = dateOfSale
        self.paidWith = paidWith
    }
}

struct SaleToSubmit : Codable {
    var totalPrice: Double
    var gamesId: [String?] // Liste des IDs des jeux vendus
    var totalCommission: Double
    var dateOfSale: Date
    var paidWith : Payment
    
    // Mapping des clés JSON
    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case gamesId = "games_id"
        case totalCommission = "total_commission"
        case dateOfSale = "sale_date"
        case paidWith = "paid_with"
    } }
