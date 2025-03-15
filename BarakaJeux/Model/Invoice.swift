import Foundation

struct Invoice: Identifiable, Codable {
    var id: String
    var saleId: Sale
    var buyerId: String
    
    init(id: String = "", saleId: Sale, buyerId: String = "") {
        self.id = id
        self.saleId = saleId
        self.buyerId = buyerId
    }
}

