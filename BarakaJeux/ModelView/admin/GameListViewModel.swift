import Foundation
import Combine

class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let apiURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game"

    init() {
        fetchGames()
    }
    
    /// Récupère la liste des jeux depuis l'API
    func fetchGames() {
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
            // Spécification du type attendu lors du décodage
            .map { JSONHelper.decode(data: $0) as [Game]? ?? [] } // Correction ici : [Game] au lieu de [Any]
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("❌ Erreur API : \(error.localizedDescription)")
                case .finished:
                    print("✅ Récupération des jeux terminée")
                }
            }, receiveValue: { [weak self] games in
                print("✅ \(games.count) jeux récupérés")
                self?.games = games
            })
            .store(in: &cancellables)
    }

    /// Crée un nouveau jeu via l'API
    func createGame(game: GameToSubmit) {
            guard let url = URL(string: apiURL) else {
                print("❌ URL invalide pour la création du jeu")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Utilisation de JSONHelper pour encoder le jeu
            guard let jsonData = JSONHelper.encode(object: game) else {
                print("❌ Erreur lors de l'encodage JSON du jeu")
                return
            }
            
            print("🔨 JSON encodé : \(String(data: jsonData, encoding: .utf8) ?? "")")

            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    print("❌ Erreur API lors de la création du jeu : \(error.localizedDescription)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("📦 Réponse API : \(response.statusCode)")
                    if response.statusCode == 201 {
                        print("✅ Jeu créé avec succès")
                    } else {
                        print("⚠️ Réponse inattendue de l'API : \(response.statusCode)")
                    }
                }
                
                DispatchQueue.main.async {
                    self?.fetchGames()
                }
            }.resume()
        }}

