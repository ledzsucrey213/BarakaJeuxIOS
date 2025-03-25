import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("📅 Évènements")
                            .font(.title)
                            .bold()
                            .padding(.top, 40)

                        ForEach(viewModel.events) { event in
                            EventCard(event: event, onUpdate: {
                                viewModel.fetchEvents()
                            })
                        }

                        Button(action: {
                            let newEvent = Event(name: "Nouvel Evènement")
                            viewModel.createEvent(event: newEvent)
                        }) {
                            Text("➕ Ajouter un événement")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .onAppear {
                viewModel.fetchEvents()
            }
            .navigationBarItems(
                leading:
                    HStack {
                        DropdownMenu() // Menu à gauche
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
            )
        }
    }
}

// Composant de carte événement
struct EventCard: View {
    let event: Event
    var onUpdate: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("📌 \(event.name)")
                .font(.headline)

            NavigationLink(destination: EventView(event: event, onUpdate: onUpdate)) {
                Text("🔍 Consulter")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}


