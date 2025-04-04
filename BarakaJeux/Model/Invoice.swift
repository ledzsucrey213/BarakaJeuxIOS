import Foundation

protocol InvoiceProtocol {
    
    /// Identifiant unique de la facture
    var id: String { get }
    
    /// Identifiant de la vente associée à la facture
    var saleId: String { get }
    
    /// Identifiant de l'acheteur
    var buyerId: String { get }
}

class Invoice: InvoiceProtocol, ObservableObject, Identifiable, Codable {
    var id: String
    var saleId: String  // saleId est maintenant une chaîne de caractères
    var buyerId: String
    
    // Mapping des clés JSON si besoin
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Si l'API utilise "_id", on le mappe à "id"
        case saleId = "sale_id"
        case buyerId = "buyer_id"
    }
    
    // Initialiseur personnalisé pour Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        saleId = try container.decode(String.self, forKey: .saleId)  // Correction ici
        buyerId = try container.decode(String.self, forKey: .buyerId)
    }
    
    // Initialiseur par défaut
    init(id: String = "", saleId: String = "", buyerId: String = "") {
        self.id = id
        self.saleId = saleId
        self.buyerId = buyerId
    }
}

