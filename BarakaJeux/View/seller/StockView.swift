import SwiftUI

struct StockView: View {
    @StateObject private var viewModel: StockViewModel
    let seller: User
    
    init(seller: User) {
        self.seller = seller
        _viewModel = StateObject(wrappedValue: StockViewModel(sellerID: seller.id ?? ""))
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Stock du vendeur")
                    .font(.title)
                    .bold()
                    .padding(.top, 40)
                
                Text("Jeux en vente")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack {
                        // Affichage de tous les jeux en vente
                        ForEach(viewModel.gamesInSale) { gameLabel in
                            HStack {
                                if let gameName = viewModel.gameNames[gameLabel.gameId] {
                                    Text(gameName)
                                        .font(.subheadline)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("Nom inconnu")
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Text("€ \(gameLabel.price, specifier: "%.2f")")
                                    .foregroundColor(.gray)
                                Text(gameLabel.condition.rawValue)
                                    .foregroundColor(gameLabel.condition == .new ? .green : .orange)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.bottom, 5)
                        }
                    }
                    .padding(.top, 5)
                }
                .frame(maxHeight: 400)
                
                Text("Jeux vendus")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack {
                        // Affichage de tous les jeux vendus
                        ForEach(viewModel.gamesSold) { gameLabel in
                            HStack {
                                if let gameName = viewModel.gameNames[gameLabel.gameId] {
                                    Text(gameName)
                                        .font(.subheadline)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("Nom inconnu")
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Text("€ \(gameLabel.price, specifier: "%.2f")")
                                    .foregroundColor(.gray)
                                Text(gameLabel.condition.rawValue)
                                    .foregroundColor(gameLabel.condition == .new ? .green : .orange)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.bottom, 5)
                        }
                    }
                    .padding(.top, 5)
                }
                .frame(maxHeight: 400)
                
                .onAppear {
                    viewModel.fetchGamesInSale()
                    viewModel.fetchGamesSold()
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
    }
}
