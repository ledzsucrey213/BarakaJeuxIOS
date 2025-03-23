import Foundation
import Combine

class InvoiceViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var sales: [Sale] = []  // Stocke les ventes récupérées
    @Published var salesGames: [String: [GameLabel]] = [:] // Associe une vente (Sale.id) à ses jeux (Game)
    
    private var cancellables = Set<AnyCancellable>()
    private let buyerID: String
    
    private let invoiceAPIURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/invoice/buyer/"
    private let saleAPIURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/sale/"
    private let gameAPIURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label/"

    init(buyerID: String) {
        self.buyerID = buyerID
        fetchInvoices()
    }
    
    /// **Récupère la liste des factures depuis l'API**
    func fetchInvoices() {
        guard let url = URL(string: "\(invoiceAPIURL)\(buyerID)") else {
            print("❌ URL invalide")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📥 JSON brut reçu (factures) : \(jsonString)")
                }
            })
            .map { data -> [Invoice] in
                if let decodedInvoices: [Invoice] = JSONHelper.decode(data: data) {
                    return decodedInvoices
                } else {
                    print("❌ Erreur lors du décodage des factures")
                    return []
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Erreur de requête (factures) : \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] invoices in
                print("✅ \(invoices.count) factures récupérées")
                self?.invoices = invoices
                self?.fetchSales()  // Lancement du fetch des ventes après récupération des factures
            })
            .store(in: &cancellables)
    }

    /// **Récupère les ventes (`Sale`) associées aux factures**
    func fetchSales() {
        let saleIDs = invoices.map { $0.saleId }

        let publishers = saleIDs.map { saleID -> AnyPublisher<Sale, Never> in
            guard let url = URL(string: "\(saleAPIURL)\(saleID)") else {
                print("❌ URL invalide pour la vente \(saleID)")
                return Just(Sale()).eraseToAnyPublisher()
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .handleEvents(receiveOutput: { data in
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("📥 JSON brut reçu (vente \(saleID)) : \(jsonString)")
                    }
                })
                .decode(type: Sale.self, decoder: decoder) // Vérifie si JSON renvoyé est un objet unique
                .catch { error -> Just<Sale> in
                    print("❌ Erreur récupération vente \(saleID) : \(error.localizedDescription)")
                    return Just(Sale())
                }
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] sales in
                let validSales = sales.filter { !($0.id?.isEmpty ?? false) }
                self?.sales = validSales
                print("✅ \(validSales.count) ventes récupérées")
                
                validSales.forEach { self?.fetchGameLabels(for: $0) }
            })
            .store(in: &cancellables)
    }


    /// **Récupère les jeux (`Game`) pour une vente (`Sale`) donnée**
    func fetchGameLabels(for sale: Sale) {
        let gameIDs = sale.gamesId

        let publishers = gameIDs.map { gameID -> AnyPublisher<GameLabel, Never> in
            guard let url = URL(string: "\(gameAPIURL)\(gameID)") else {
                print("❌ URL invalide pour le jeu \(gameID)")
                return Just(GameLabel()).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: GameLabel.self, decoder: JSONDecoder())
                .catch { error -> Just<GameLabel> in
                    print("❌ Erreur récupération jeu \(gameID) : \(error.localizedDescription)")
                    return Just(GameLabel())
                }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] games in
                self?.salesGames[sale.id ?? "defaultID"] = games.filter { !($0.id ?? "").isEmpty } // Associe les jeux à la vente
                print("✅ \(games.count) jeux récupérés pour la vente \(sale.id)")
            })
            .store(in: &cancellables)
    }
}

