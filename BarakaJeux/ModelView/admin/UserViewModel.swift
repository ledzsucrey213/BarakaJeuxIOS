import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        print("self.user.id")
    }
    
    /// Met à jour l'utilisateur via l'API
    func updateUser() {
        guard let userID = self.user.id else {
            print("❌ ID de l'utilisateur est nil")
            return
        }

        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/user/\(userID)") else {
            print("❌ URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Utilisation de JSONHelper pour encoder l'utilisateur
        guard let jsonData = JSONHelper.encode(object: user) else {
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

