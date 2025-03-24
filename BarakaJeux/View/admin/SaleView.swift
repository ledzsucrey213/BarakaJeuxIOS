import SwiftUI

struct SaleView: View {
    @StateObject private var viewModel: SaleViewModel
    @Environment(\.presentationMode) var presentationMode
    var onUpdate: (() -> Void)?

    init(sale: Sale, onUpdate: (() -> Void)? = nil) {
        self.onUpdate = onUpdate
        _viewModel = StateObject(wrappedValue: SaleViewModel(sale: sale))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                // Date Picker
                Text("🗓 Date de l'achat:")
                    .font(.headline)
                DatePicker(
                    "",
                    selection: $viewModel.sale.dateOfSale,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.bottom, 10)
                
                // Prix total
                Text("💰 Prix total: \(String(format: "%.2f", viewModel.sale.totalPrice)) €")
                    .font(.subheadline)

                // Liste des jeux achetés
                Text("🛒 Jeux achetés:")
                    .font(.subheadline)
                    .bold()

                VStack(alignment: .leading, spacing: 5) {
                    if !viewModel.salesGames.isEmpty {
                        ForEach(viewModel.salesGames, id: \.id) { game in
                            Text("- \(game.gameId) • \(String(format: "%.2f", game.price)) €")
                                .font(.body)
                        }
                    } else {
                        Text("⏳ Chargement des jeux...")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 10)


                // Mode de paiement Picker
                Text("💳 Paiement:")
                    .font(.subheadline)
                    .bold()
                
                Picker("Mode de paiement", selection: $viewModel.sale.paidWith) {
                    Text("Carte").tag(Payment.card)
                    Text("Espèce").tag(Payment.cash)
                }
                .pickerStyle(SegmentedPickerStyle()) // Utilise un style segmenté pour choisir facilement
                .padding(.bottom, 10)

                Divider()
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 2)

            // Bouton de sauvegarde
            Button(action: {
                viewModel.updateSale()
                onUpdate?()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Sauvegarder")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .padding(.top, 20)
        
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
 
// Formate la date proprement
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

