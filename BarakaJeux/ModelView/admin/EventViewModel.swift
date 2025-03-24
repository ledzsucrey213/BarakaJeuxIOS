import Foundation
import Combine

class EventViewModel: ObservableObject {
    @Published var event: Event
    private var cancellables = Set<AnyCancellable>()
    
    init(event: Event) {
        self.event = event
        print("self.event.id")
    }
    
    /// Met à jour l'événement via l'API
    func updateEvent() {
        guard let eventID = self.event.id else {
            print("❌ ID de l'événement est nil")
            return
        }

        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/event/\(eventID)") else {
            print("❌ URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Utilisation de JSONHelper pour encoder l'événement
        guard let jsonData = JSONHelper.encode(object: event) else {
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
