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
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Stock du vendeur")
                            .font(.title)
                            .bold()
                            .padding(.top, 40)
                        
                        SectionView(title: "Jeux en vente", games: viewModel.gamesInSale, gameNames: viewModel.gameNames)
                            .frame(maxHeight: 300)
                        SectionView(title: "Jeux vendus", games: viewModel.gamesSold, gameNames: viewModel.gameNames)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .onAppear {
                viewModel.fetchGamesInSale()
                viewModel.fetchGamesSold()
            }
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
}

struct SectionView: View {
    let title: String
    let games: [GameLabel]
    let gameNames: [String: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.top)
            
            if games.isEmpty {
                Text("Aucun jeu disponible")
                    .foregroundColor(.gray)
                    .padding(.top)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(games) { gameLabel in
                            GameCard(gameLabel: gameLabel, gameName: gameNames[gameLabel.gameId] ?? "Nom inconnu")
                        }
                    }
                    .padding(.top, 5)
                }
                .frame(maxHeight: 400)
            }
        }
    }
}

struct GameCard: View {
    let gameLabel: GameLabel
    let gameName: String
    
    var body: some View {
        HStack {
            Text(gameName)
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("€ \(gameLabel.price, specifier: "%.2f")")
                .foregroundColor(.gray)
            
            Text(gameLabel.condition.rawValue)
                .foregroundColor(gameLabel.condition == .new ? .green : .orange)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.bottom, 5)
    }
}

