import SwiftUI


struct SellerReportView: View {
    let report: Report
    let eventName: String? // Ajout du nom de l'événement
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Détails du bilan financier")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 40)

                        DetailRow(label: "🗓 Date", value: formattedDate(report.reportDate))
                        DetailRow(label: "🎮 Événement", value: eventName ?? "Événement inconnu")
                        DetailRow(label: "💰 Montant total gagné", value: "\(String(format: "%.2f", report.totalEarned)) €")
                        DetailRow(label: "💸 Montant total dû", value: "\(String(format: "%.2f", report.totalDue)) €")

                        VStack(spacing: 15) {
                            ActionSellerButton(title: "📄 Imprimer", color: .blue) {
                                print("Bilan financier imprimé")
                            }
                            ActionSellerButton(title: "💰 Récupérer gains", color: .green) {
                                print("Récupérer gains")
                            }
                            ActionSellerButton(title: "🎮 Récupérer jeux non vendus", color: .red) {
                                print("Récupérer jeux non vendus")
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarItems(
                                    leading:
                                        HStack {
                                            DropdownMenu() // Menu à gauche
                                            Spacer()

                                        }
                                        .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
                                )
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Composant pour afficher chaque détail
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// Composant pour les boutons d'action
struct ActionSellerButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}

