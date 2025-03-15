import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil
    
    func login() {
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/user/login") else {
            errorMessage = "URL invalide"
            return
        }
        
        let requestBody: [String: String] = [
            "name": username,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            errorMessage = "Erreur lors de la conversion en JSON"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Erreur de connexion : \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Réponse invalide du serveur"
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        
                        // Stocker le token pour les futures requêtes
                        UserDefaults.standard.set(token, forKey: "authToken")
                        self.isAuthenticated = true
                    } else {
                        self.errorMessage = "Réponse inattendue du serveur"
                    }
                
                case 400:
                    self.errorMessage = "Mot de passe incorrect"
                case 403:
                    self.errorMessage = "Accès refusé : seul un administrateur ou un manager peut se connecter"
                case 404:
                    self.errorMessage = "Utilisateur non trouvé"
                default:
                    self.errorMessage = "Erreur inconnue (\(httpResponse.statusCode))"
                }
            }
        }.resume()
    }
}

