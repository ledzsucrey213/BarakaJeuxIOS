import Foundation
import Combine

class SaleViewModel: ObservableObject {
    @Published var sale: Sale
    private var cancellables = Set<AnyCancellable>()
    @Published var salesGames : [GameLabel] = []
    private let gameAPIURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label/"
    
    init(sale: Sale) {
        self.sale = sale
        print(self.sale.id)
        fetchGameLabels(for: sale)
    }
    
    /// Met à jour l'événement via l'API
    func updateSale() {
        guard let saleID = self.sale.id else {
            print("❌ ID de l'événement est nil")
            return
        }
        
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/sale/\(saleID)") else {
            print("❌ URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(sale)
            request.httpBody = jsonData
        } catch {
            print("❌ Erreur encodage JSON : \(error.localizedDescription)")
            return
        }
        
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
                // Retourne un publisher avec une valeur par défaut en cas d'erreur d'URL
                return Just(GameLabel()).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: GameLabel.self, decoder: JSONDecoder())
                .catch { error -> Just<GameLabel> in
                    print("❌ Erreur récupération jeu \(gameID) : \(error.localizedDescription)")
                    return Just(GameLabel()) // Retourne une instance vide en cas d'erreur
                }
                .eraseToAnyPublisher()
        }
        
        // Combine les publishers et met à jour `salesGames` lorsque toutes les requêtes sont terminées
        Publishers.MergeMany(publishers)
            .collect() // Collecte les résultats dans un tableau
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("✅ Tous les jeux récupérés")
                case .failure(let error):
                    print("❌ Erreur lors de la récupération des jeux : \(error)")
                }
            }, receiveValue: { [weak self] gameLabels in
                self?.salesGames = gameLabels // Met à jour le tableau des jeux récupérés
            })
            .store(in: &cancellables) // Enregistre l'abonnement dans cancellables
    }
}

