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
    
    // Fonction générique pour encoder un objet en données JSON
        static func encode<T: Encodable>(object: T) -> Data? {
            let encoder = JSONEncoder()
            do {
                let encodedData = try encoder.encode(object)
                return encodedData
            } catch {
                print("Erreur d'encodage : \(error)")
                return nil
            }
        }
}

