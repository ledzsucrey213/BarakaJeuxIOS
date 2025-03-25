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
        NavigationView {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("🛍️ Détails de la vente")
                            .font(.title)
                            .bold()
                            .padding(.top, 40)

                        VStack(alignment: .leading, spacing: 15) {
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

                            // Prix total
                            Text("💰 Prix total: \(String(format: "%.2f", viewModel.sale.totalPrice)) €")
                                .font(.subheadline)
                                .bold()

                            // Liste des jeux achetés
                            Text("🛒 Jeux achetés:")
                                .font(.subheadline)
                                .bold()

                            VStack(alignment: .leading, spacing: 5) {
                                if !viewModel.salesGames.isEmpty {
                                    ForEach(viewModel.salesGames, id: \.id) { game in
                                        Text("🎮 \(game.gameId) - \(String(format: "%.2f", game.price)) €")
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
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(radius: 5)

                        // Bouton de sauvegarde
                        Button(action: {
                            viewModel.updateSale()
                            onUpdate?()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("💾 Sauvegarder")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
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
                    .frame(maxWidth: .infinity)
            )
        }
    }
}

// Formate la date proprement
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

