import Foundation
import Combine

class SaleListViewModel: ObservableObject {
    @Published var sales: [Sale] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let apiURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/sale"

    init() {
        fetchSales()
    }
    
    /// Récupère la liste des événements depuis l'API
    func fetchSales() {
        guard let url = URL(string: apiURL) else {
            print("❌ URL invalide")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📥 JSON brut reçu : \(jsonString)")
                }
            })
            .decode(type: [Sale].self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("❌ Erreur de décodage : \(error.localizedDescription)")

                    // ✅ Debugging avancé
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .typeMismatch(let key, let context):
                            print("❌ TypeMismatch Key: \(key) - \(context.debugDescription)")
                        case .valueNotFound(let key, let context):
                            print("❌ ValueNotFound Key: \(key) - \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("❌ KeyNotFound Key: \(key) - \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("❌ DataCorrupted: \(context.debugDescription)")
                        @unknown default:
                            print("❌ Erreur inconnue")
                        }
                    }

                case .finished:
                    print("✅ Récupération des événements terminée")
                }
            }, receiveValue: { [weak self] sales in
                print("✅ \(sales.count) ventes récupérées")
                self?.sales = sales
            })
            .store(in: &cancellables)
    }


}

