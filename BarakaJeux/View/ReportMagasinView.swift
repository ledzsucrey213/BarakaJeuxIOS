import SwiftUI

struct ReportMagasinView: View {
    @StateObject private var viewModel: ReportViewModel

    init() {
        _viewModel = StateObject(wrappedValue: ReportViewModel(sellerID: "675c75c5cd3b594a7528034f"))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Rapports financiers de BarakaJeux")
                        .font(.title)
                        .bold()
                        .padding(.top, 40)
                    
                    ForEach(viewModel.reports, id: \.id) { report in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("🗓 Date du rapport: \(formattedDate(report.reportDate))")
                                .font(.headline)
                            
                            if let eventName = viewModel.eventsNames[report.eventId] {
                                Text("🎮 Événement: \(eventName)")
                                    .font(.subheadline)
                            }

                            Text("💰 Montant total gagné: \(String(format: "%.2f", report.totalEarned)) €")
                                .font(.subheadline)

                            Text("💸 Montant total dû: \(String(format: "%.2f", report.totalDue)) €")
                                .font(.subheadline)
                            
                            // Ajouter le bouton "Imprimer"
                            Button(action: {
                                print("Rapport imprimé")
                            }) {
                                Text("Imprimer")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            .padding(.top, 10)

                            Divider()
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .onAppear {
                viewModel.fetchReports()
            }
            
            .navigationBarItems(
                leading:
                    HStack {
                        DropdownMenu() // Menu à gauche
                        Spacer()
                        Image("banner") // Bannière légèrement décalée
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100) // Ajuster la hauteur
                            .padding(.leading, 10) // Décale vers la gauche
                            .offset(y: 20) // Décale vers le bas
                    }
                    .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
            )
        }
    }

    // Formate la date proprement
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


