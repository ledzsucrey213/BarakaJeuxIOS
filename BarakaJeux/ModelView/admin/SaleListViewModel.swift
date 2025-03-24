import Foundation
import Combine

class SaleListViewModel: ObservableObject {
    @Published var sales: [Sale] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let apiURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/sale"

    init() {
        fetchSales()
    }
    
    /// Récupère la liste des ventes depuis l'API
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
            // Utilisation de JSONHelper pour le décodage
            .map { JSONHelper.decode(data: $0) as [Sale]? ?? [] } // Correction ici : [Sale] au lieu de [Any]
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("❌ Erreur API : \(error.localizedDescription)")
                case .finished:
                    print("✅ Récupération des ventes terminée")
                }
            }, receiveValue: { [weak self] sales in
                print("✅ \(sales.count) ventes récupérées")
                self?.sales = sales
            })
            .store(in: &cancellables)
    }
}

