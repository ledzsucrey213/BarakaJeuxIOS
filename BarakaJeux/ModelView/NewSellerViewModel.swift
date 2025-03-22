import Foundation

class NewSellerViewModel: ObservableObject {
    @Published var firstname: String = ""
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var address: String = ""

    func createSeller(completion: @escaping () -> Void) {
        let newSeller = UserToSubmit(
            firstname: firstname,
            name: name,
            email: email,
            address: address,
            role: .seller  // Le rôle est fixé à "seller"
        )


        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/user") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(newSeller)
            request.httpBody = jsonData
        } catch {
            print("Erreur d'encodage JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur réseau: \(error)")
                return
            }
            DispatchQueue.main.async {
                completion() // Ferme la vue après succès
            }
        }.resume()
    }
}

