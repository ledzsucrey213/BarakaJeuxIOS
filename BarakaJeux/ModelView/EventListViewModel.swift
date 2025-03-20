import Foundation
import Combine

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let apiURL = "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/event"

    init() {
        fetchEvents()
    }
    
    /// Récupère la liste des événements depuis l'API
    func fetchEvents() {
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
            .decode(type: [Event].self, decoder: {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return decoder
            }())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("❌ Erreur de décodage : \(error.localizedDescription)")

                    // ✅ Debugging avancé
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
                    print("✅ Récupération des événements terminée")
                }
            }, receiveValue: { [weak self] events in
                print("✅ \(events.count) événements récupérés")
                self?.events = events
            })
            .store(in: &cancellables)
    }


    /// Crée un nouvel événement via l'API
    func createEvent(event: Event) {
        guard let url = URL(string: apiURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(event)
            request.httpBody = jsonData
        } catch {
            print("❌ Erreur encodage JSON : \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("❌ Erreur API : \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.fetchEvents()
            }
        }.resume()
    }
}

