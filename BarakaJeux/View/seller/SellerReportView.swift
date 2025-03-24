import SwiftUI

struct SellerReportView: View {
    let report: Report
    let eventName: String? // Ajout du nom de l'événement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Détails du bilan financier")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            Text("🗓 Date: \(formattedDate(report.reportDate))")
                .font(.headline)
            
            Text("🎮 Événement: \(eventName ?? "Evenement inconnu") ") // Affichage du nom de l'événement
                .font(.subheadline)
            
            Text("💰 Montant total gagné: \(String(format: "%.2f", report.totalEarned)) €")
                .font(.subheadline)
            
            Text("💸 Montant total dû: \(String(format: "%.2f", report.totalDue)) €")
                .font(.subheadline)
            
            Button(action: {
                print("Bilan financier imprimé")
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
            
            Button(action: {
                print("Récupérer gains")
            }) {
                Text("Récupérer gains")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.top, 10)
            
            Button(action: {
                print("jeux")
            }) {
                Text("Récupérer jeux non vendus")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.top, 10)
            
       
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
        .navigationTitle("Rapport de vente")
        .navigationBarItems(
                                leading:
                                    HStack {
                                        DropdownMenu() // Menu à gauche
                                        Spacer()

                                    }
                                    .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
                            )
        

    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

