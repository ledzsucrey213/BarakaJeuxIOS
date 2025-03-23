import SwiftUI
import Combine

class ReportViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let sellerID: String
    private let reportURL: URL
    @Published var reports: [Report] = []
    @Published var eventsNames: [String: String] = [:]

    init(sellerID: String) {
        self.sellerID = sellerID
        self.reportURL = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/report/seller/\(sellerID)")!
    }

    /// Récupère les rapports du vendeur
    func fetchReports() {
        URLSession.shared.dataTaskPublisher(for: reportURL)
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📥 JSON brut reçu : \(jsonString)")
                }
            })
            .decode(type: [Report].self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("❌ Erreur lors de la récupération des rapports : \(error.localizedDescription)")

                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .typeMismatch(let key, let context):
                            print("❌ TypeMismatch Key: \(key) - \(context.debugDescription)")
                        case .valueNotFound(let key, let context):
                            print("❌ ValueNotFound Key: \(key) - \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("❌ KeyNotFound Key: \(key) - \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("❌ DataCorrupted: \(context.debugDescription)")
                        @unknown default:
                            print("❌ Erreur inconnue")
                        }
                    }

                case .finished:
                    print("✅ Récupération des rapports terminée")
                }
            }, receiveValue: { [weak self] reports in
                print("✅ \(reports.count) rapports récupérés")
                self?.reports = reports
                self?.fetchEventNames() // Appel après récupération des rapports
            })
            .store(in: &cancellables)
    }

    /// Récupère les noms des événements associés aux rapports
    private func fetchEventNames() {
        let group = DispatchGroup()  // Gestion des requêtes asynchrones
        
        for report in reports {
            group.enter()

            guard let eventUrl = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/event/\(report.eventId)") else {
                print("❌ URL invalide pour eventId: \(report.eventId)")
                group.leave()
                continue
            }

            URLSession.shared.dataTaskPublisher(for: eventUrl)
                .map(\.data)
                .decode(type: Event.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ Erreur lors du chargement de l'événement \(report.eventId) : \(error)")
                    }
                    group.leave()
                }, receiveValue: { [weak self] event in
                    self?.eventsNames[report.eventId] = event.name
                })
                .store(in: &cancellables)
        }

        group.notify(queue: DispatchQueue.main) {
            print("✅ Tous les noms des événements ont été récupérés.")
        }
    }
}

