import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var game: Game
    private var cancellables = Set<AnyCancellable>()
    
    init(game: Game) {
        self.game = game
        print("self.game.id")
    }
    
    /// Met à jour le jeu via l'API
    func updateGame() {
        guard let gameID = self.game.id else {
            print("❌ ID du jeu est nil")
            return
        }

        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game/\(gameID)") else {
            print("❌ URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Utilisation de JSONHelper pour encoder le jeu
        guard let jsonData = JSONHelper.encode(object: game) else {
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
}

