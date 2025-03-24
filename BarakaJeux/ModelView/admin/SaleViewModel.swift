import Foundation
import Combine

class SaleViewModel: ObservableObject {
    @Published var sale: Sale
    private var cancellables = Set<AnyCancellable>()
    @Published var salesGames: [GameLabel] = []
    private let gameAPIURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label/"
    
    init(sale: Sale) {
        self.sale = sale
        print(self.sale.id)
        fetchGameLabels(for: sale)
    }
    
    /// Met à jour la vente via l'API
    func updateSale() {
        guard let saleID = self.sale.id else {
            print("❌ ID de la vente est nil")
            return
        }
        
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/sale/\(saleID)") else {
            print("❌ URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Utilisation de JSONHelper pour encoder la vente
        guard let jsonData = JSONHelper.encode(object: sale) else {
            print("❌ Erreur encodage JSON")
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Erreur API : \(error.localizedDescription)")
            }
        }.resume()
    }
    
    /// Récupère les jeux pour une vente donnée et met à jour `salesGames`
    func fetchGameLabels(for sale: Sale) {
        let gameIDs = sale.gamesId
        
        // Crée un tableau de Publishers pour récupérer chaque jeu par son ID
        let publishers = gameIDs.compactMap { gameID -> AnyPublisher<GameLabel, Never> in
            guard let url = URL(string: "\(gameAPIURL)\(gameID)") else {
                print("❌ URL invalide pour le jeu \(gameID)")
                return Just(GameLabel()).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .map { JSONHelper.decode(data: $0) ?? GameLabel() } // Utilisation de JSONHelper
                .catch { error -> Just<GameLabel> in
                    print("❌ Erreur récupération jeu \(gameID) : \(error.localizedDescription)")
                    return Just(GameLabel())
                }
                .eraseToAnyPublisher()
        }
        
        // Combine les publishers et met à jour `salesGames` lorsque toutes les requêtes sont terminées
        Publishers.MergeMany(publishers)
            .collect()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ Tous les jeux récupérés")
                case .failure(let error):
                    print("❌ Erreur lors de la récupération des jeux : \(error)")
                }
            }, receiveValue: { [weak self] gameLabels in
                self?.salesGames = gameLabels
            })
            .store(in: &cancellables)
    }
}

