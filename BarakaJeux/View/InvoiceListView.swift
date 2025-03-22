import SwiftUI

struct InvoiceListView: View {
    @StateObject private var viewModel: InvoiceViewModel
    let buyer: User

    init(buyer: User) {
        self.buyer = buyer
        _viewModel = StateObject(wrappedValue: InvoiceViewModel(buyerID: buyer.id ?? ""))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Factures de \(buyer.name)")
                        .font(.title)
                        .bold()
                        .padding(.top, 40)
                    
                    
                    ForEach(viewModel.sales, id: \.id) { sale in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("🗓 Date de l'achat: \(formattedDate(sale.dateOfSale))")
                                .font(.headline)
                            
                            Text("💰 Prix total: \(String(format: "%.2f", sale.totalPrice)) €")
                                .font(.subheadline)

                            Text("🛒 Jeux achetés:")
                                .font(.subheadline)
                                .bold()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                if let gameLabels = viewModel.salesGames[sale.id!] {
                                    ForEach(gameLabels, id: \.id) { game in
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

                            Text("💳 Paiement: \(sale.paidWith == .card ? "Carte" : "Espèce")")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(sale.paidWith == .card ? .blue : .green)

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
                viewModel.fetchSales()
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

