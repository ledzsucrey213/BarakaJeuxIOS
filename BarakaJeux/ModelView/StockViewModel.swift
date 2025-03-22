import SwiftUI
import Combine



class StockViewModel: ObservableObject {
    @Published var gamesInSale: [GameLabel] = []
    @Published var gamesSold: [GameLabel] = []
    @Published var gameNames: [String: String] = [:]
    private var cancellables = Set<AnyCancellable>()
    private let sellerID: String
    private let stockURL: URL

    init(sellerID: String) {
        self.sellerID = sellerID
        self.stockURL = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/stock/seller/\(sellerID)")!
    }

    /// Récupère les jeux en vente
    func fetchGamesInSale() {
        URLSession.shared.dataTaskPublisher(for: stockURL)
            .map(\.data)
            .decode(type: Stock.self, decoder: JSONDecoder())
            .map { $0.gamesId }
            .flatMap { gameIds in
                Publishers.MergeMany(gameIds.map { gameId in
                    self.fetchGameLabel(gameId: gameId)
                })
            }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Erreur lors de la récupération du stock : \(error)")
                }
            }, receiveValue: { [weak self] games in
                self?.gamesInSale = games
                print("✅ Jeux en vente récupérés avec succès")
                self?.fetchGameNames() // Appeler la fonction après la récupération des jeux
            })
            .store(in: &cancellables)
    }

    func fetchGamesSold() {
        URLSession.shared.dataTaskPublisher(for: stockURL)
            .map(\.data)
            .decode(type: Stock.self, decoder: JSONDecoder())
            .map { $0.gamesSold }
            .flatMap { gameIds in
                Publishers.MergeMany(gameIds.map { gameId in
                    self.fetchGameLabel(gameId: gameId)
                })
            }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Erreur lors de la récupération des jeux vendus : \(error)")
                }
            }, receiveValue: { [weak self] games in
                self?.gamesSold = games
                print("✅ Jeux vendus récupérés avec succès")
                self?.fetchGameNames() // Appeler la fonction après la récupération des jeux
            })
            .store(in: &cancellables)
    }


    /// Récupère un `GameLabel` à partir d'un `gameId`
    private func fetchGameLabel(gameId: String) -> AnyPublisher<GameLabel, Never> {
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label/\(gameId)") else {
            return Empty().eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GameLabel.self, decoder: JSONDecoder())
            .catch { _ in Empty<GameLabel, Never>() } // Si erreur, on ignore simplement
            .eraseToAnyPublisher()
    }



    /// Récupère les noms des jeux
    private func fetchGameNames() {
        let allGames = gamesSold + gamesInSale  // Fusion des deux tableaux
        
        let group = DispatchGroup()  // Déclare un DispatchGroup pour gérer les tâches asynchrones
        
        for gameLabel in allGames {
            group.enter()  // Indique qu'une tâche asynchrone commence

            guard let gameUrl = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game/\(gameLabel.gameId)") else {
                group.leave()  // Si l'URL est invalide, on quitte directement
                continue
            }

            URLSession.shared.dataTaskPublisher(for: gameUrl)
                .map { data, response -> Data in
                    print("✅ Données du jeu avec gameId : \(gameLabel.gameId) reçues.")
                    return data
                }
                .decode(type: Game.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ Erreur lors du chargement du jeu pour gameId \(gameLabel.gameId) : \(error)")
                    }
                }, receiveValue: { game in
                    // Associer gameId au nom du jeu dans le dictionnaire
                    self.gameNames[gameLabel.gameId] = game.name
                    group.leave()  // Indiquer que la tâche est terminée
                })
                .store(in: &self.cancellables)
        }

        // Une fois que toutes les requêtes sont terminées
        group.notify(queue: DispatchQueue.main) {
            print("✅ Tous les noms des jeux ont été récupérés.")
        }
    }

}

