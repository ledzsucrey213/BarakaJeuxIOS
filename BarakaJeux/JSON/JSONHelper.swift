import Foundation

// Structure pour aider à lire et décoder des données JSON
struct JSONHelper {
    
    
    // Fonction générique pour décoder des données JSON
    static func decode<T: Decodable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("Erreur de décodage : \(error)")
            return nil
        }
    }
}

