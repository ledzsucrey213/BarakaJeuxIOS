import SwiftUI
import Combine
import Foundation

class SearchSellerViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var sellers: [User] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let apiURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/user/role/seller"

    init() {
        fetchSellers()
    }

    func fetchSellers() {
        guard let url = URL(string: apiURL) else {
            print("URL invalide : \(apiURL)")  // Vérifie que l'URL est valide
            return
        }

        print("Envoi de la requête GET à : \(url)")  // Vérifie que la requête est envoyée

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                if let users: [User] = JSONHelper.decode(data: data) {
                    return users.filter { $0.role == .seller }
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Erreur API : \(error.localizedDescription)")  // Affiche l'erreur si la requête échoue
                }
            }, receiveValue: { (filteredSellers: [User]) in
                print("Données reçues : \(filteredSellers)")  // Affiche les données des utilisateurs récupérées
                self.sellers = filteredSellers
            })
            .store(in: &cancellables)
    }
 

    var filteredSellers: [User] {
        if searchQuery.isEmpty {
            return sellers
        } else {
            return sellers.filter {
                $0.firstname.localizedCaseInsensitiveContains(searchQuery) ||
                $0.name.localizedCaseInsensitiveContains(searchQuery) ||
                $0.email.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}

