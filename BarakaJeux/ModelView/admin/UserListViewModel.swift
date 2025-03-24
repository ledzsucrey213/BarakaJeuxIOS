import Foundation
import Combine

class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let apiURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/user"

    init() {
        fetchUsers()
    }
    
    /// Récupère la liste des utilisateurs depuis l'API
    func fetchUsers() {
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
            .map { JSONHelper.decode(data: $0) as [User]? ?? [] } // Correction ici : [User] au lieu de [Any]
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("❌ Erreur API : \(error.localizedDescription)")
                case .finished:
                    print("✅ Récupération des utilisateurs terminée")
                }
            }, receiveValue: { [weak self] users in
                print("✅ \(users.count) utilisateurs récupérés")
                self?.users = users
            })
            .store(in: &cancellables)
    }

    /// Crée un nouvel utilisateur via l'API
    func createUser(user: User) {
        guard let url = URL(string: apiURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Utilisation de JSONHelper pour encoder l'utilisateur
        guard let jsonData = JSONHelper.encode(object: user) else {
            print("❌ Erreur encodage JSON")
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ Erreur API : \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.fetchUsers()
            }
        }.resume()
    }
}

