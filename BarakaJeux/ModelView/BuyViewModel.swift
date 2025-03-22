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
            let matchingGameIds = gameNames.filter { $0.value.lowercased().contains(searchText.lowercased()) }.map { $0.key }
            filteredAvailableGames = availableGames.filter { matchingGameIds.contains($0.gameId) }
        }
    }

    /// **Calcule le coût total des jeux dans le panier**
    func coutTotal() -> Double {
        return gamesInCart.reduce(0) { $0 + $1.price }
    }
    
    func endPurchase() -> Void {
    }
    
}

