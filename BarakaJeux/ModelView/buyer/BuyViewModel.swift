import Foundation
import SwiftUI
import Combine

class BuyViewModel: ObservableObject {
    @Published var availableGames: [GameLabel] = []
    @Published var gamesInCart: [GameLabel] = []
    @Published var searchText: String = "" {
        didSet {
            updateFilteredGamesByName()
        }
    }
    @Published var showGameList: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // Liste filtrée des jeux
    @Published var filteredAvailableGames: [GameLabel] = []
    
    // Dictionnaire gameNames pour stocker les noms de jeux associés aux gameId
    @Published var gameNames: [String: String] = [:]
    
    init() {
        UITextField.appearance().inputAssistantItem.leadingBarButtonGroups = []
        UITextField.appearance().inputAssistantItem.trailingBarButtonGroups = []
    }

    /// **Récupère tous les GameLabel disponibles**
    func fetchAvailableGames() {
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label") else { return }

        print("📡 Appel API pour récupérer les jeux disponibles...")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [GameLabel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Erreur lors du chargement des jeux disponibles : \(error)")
                }
            }, receiveValue: { [weak self] games in
                // Filtrer les jeux pour ne garder que ceux qui ont isOnSale == true
                let filteredGames = games.filter { $0.isOnSale == true }
                self?.availableGames = filteredGames
                self?.fetchGameNames() // Après avoir chargé les labels, récupérer les vrais noms des jeux
            })
            .store(in: &cancellables)
    }


    /// **Récupère le nom de chaque jeu via son gameId**
    private func fetchGameNames() {
        let publishers = availableGames.compactMap { gameLabel -> AnyPublisher<(String, String), Never>? in
            guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game/\(gameLabel.gameId)") else {
                print("❌ URL invalide pour gameId \(gameLabel.gameId)")
                return nil
            }

            return URLSession.shared.dataTaskPublisher(for: url)
                .map { data, _ -> (String, String)? in
                    guard let game = try? JSONDecoder().decode(Game.self, from: data) else {
                        print("⚠️ Impossible de décoder le jeu pour gameId \(gameLabel.gameId)")
                        return nil
                    }
                    return (gameLabel.gameId, game.name) // Associe gameId à gameName
                }
                .replaceError(with: nil)
                .compactMap { $0 }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                guard let self = self else { return }
                for (gameId, gameName) in results {
                    self.gameNames[gameId] = gameName
                }
                self.updateFilteredGamesByName()
            }
            .store(in: &cancellables)
    }

    /// **Filtre les GameLabel en fonction du nom recherché**
    private func updateFilteredGamesByName() {
        if searchText.isEmpty {
            filteredAvailableGames = availableGames
        } else {
            // Vérifier si le texte de recherche correspond à un ID de GameLabel (ID en String)
            filteredAvailableGames = availableGames.filter {
                // Si searchText correspond à l'ID de GameLabel
                $0.id?.lowercased() == searchText.lowercased() ||
                // Sinon, on filtre par le nom du jeu dans le dictionnaire gameNames
                gameNames[$0.gameId]?.lowercased().contains(searchText.lowercased()) == true
            }
        }
    }


    /// **Calcule le coût total des jeux dans le panier**
    func coutTotal() -> Double {
        return gamesInCart.reduce(0) { $0 + $1.price }
    }
    
    func endPurchase(paymentMethod: Payment) {
            let total = coutTotal()
            let sale = SaleToSubmit(
                totalPrice: total,
                gamesId: gamesInCart.map { $0.id },
                totalCommission: total * 0.05,
                dateOfSale: Date(),
                paidWith: paymentMethod
            )
            
            guard let jsonData = JSONHelper.encode(object: sale) else {
                print("❌ Erreur lors de l'encodage de la vente")
                return
            }
            
            guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/sale") else {
                print("❌ URL invalide")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("❌ Erreur lors de l'envoi de la vente : \(error)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        self.gamesInCart.removeAll()
                    }
                    print("✅ Vente envoyée avec succès")
                } else {
                    print("⚠️ Réponse inattendue de l'API")
                }
            }.resume()
        }
    
}

