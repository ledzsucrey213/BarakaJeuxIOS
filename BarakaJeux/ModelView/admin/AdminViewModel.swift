import SwiftUI
import Combine
import Foundation

class AdminViewModel: ObservableObject {
    @Published var admin: User? = nil  // Optionnel pour éviter les crashs
    private var cancellables = Set<AnyCancellable>()
    
    private let apiURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/user/role/admin"

    init() {
        fetchAdminInfos()
    }

    func fetchAdminInfos() {
        guard let url = URL(string: apiURL) else {
            print("❌ URL invalide : \(apiURL)")
            return
        }

        print("📡 Envoi de la requête GET à : \(url)")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .map { data -> [User] in
                // Spécification explicite du type attendu pour le décodeur
                return JSONHelper.decode(data: data) ?? []  // Décodage explicite en tableau d'User
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Erreur API : \(error.localizedDescription)")
                }
            }, receiveValue: { admins in
                // Assurez-vous que vous avez des utilisateurs (admin) dans votre tableau
                self.admin = admins.first(where: { $0.role == .admin })  // Met à jour admin
                if let admin = self.admin {
                    print("✅ Admin récupéré : \(admin.firstname) \(admin.name)")
                } else {
                    print("⚠️ Aucun admin trouvé")
                }
            })
            .store(in: &cancellables)
    }
}

