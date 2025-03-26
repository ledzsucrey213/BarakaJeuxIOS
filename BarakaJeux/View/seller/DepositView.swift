import SwiftUI

import SwiftUI

struct DepositView: View {
    @StateObject private var viewModel: DepositViewModel
    let seller: User
    @State private var selectedGame: Game? = nil
    @State private var price: String = ""
    @State private var condition: GameCondition = .new
    @State private var showAddGameModal = false
    @State private var showPaymentModal = false
    @State private var showSuccessView = false // ✅ Activation de la redirection

    init(seller: User) {
        self.seller = seller
        _viewModel = StateObject(wrappedValue: DepositViewModel(sellerID: seller.id ?? ""))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // ✅ Ajout du fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Dépôt de jeux")
                                .font(.title)
                                .bold()
                                .padding(.top, 40)

                            SearchBar(text: $viewModel.searchText)

                            SectionTitle(title: "Jeux disponibles")

                            if !viewModel.searchText.isEmpty {
                                GameListView(games: viewModel.filteredAvailableGames) { game in
                                    self.selectedGame = game
                                    self.showAddGameModal.toggle()
                                }
                            } else {
                                EmptyMessage(text: "Aucun jeu trouvé pour cette recherche.")
                            }

                            SectionTitle(title: "Jeux à déposer")

                            if !viewModel.gamesToDeposit.isEmpty {
                                GameDepositListView(games: viewModel.gamesToDeposit, gameNames: viewModel.gameNames)
                            } else {
                                EmptyMessage(text: "Aucun jeu à déposer")
                            }

                            StyledButton(title: "DÉPOSER") {
                                self.showPaymentModal.toggle()
                            }

                            SectionTitle(title: "Jeux déposés")

                            GameDepositListView(games: viewModel.depositedGames, gameNames: viewModel.gameNames)
                        }
                        .padding()
                    }

                    // 🔹 Navigation automatique vers SuccessView après paiement
                    NavigationLink(
                        destination: SuccessView(),
                        isActive: $showSuccessView
                    ) {
                        EmptyView()
                    }
                }
            }
            .onAppear {
                viewModel.fetchDepositedGames()
                viewModel.fetchAvailableGames()
            }
            .sheet(isPresented: $showAddGameModal) {
                AddGameModal(
                    game: selectedGame,
                    price: $price,
                    condition: $condition,
                    sellerid: self.seller.id ?? "",
                    fee: viewModel.coutTotal(),
                    onSave: { gameLabel in
                        viewModel.addGameToDeposit(gameLabel)
                        showAddGameModal = false
                    }
                )
            }
            .sheet(isPresented: $showPaymentModal) {
                PaymentModal(
                    price: viewModel.coutTotal(),
                    onPaymentSelected: { paymentMethod in
                        viewModel.endDeposit()
                        self.showPaymentModal = false
                        self.showSuccessView = true // ✅ Active la navigation
                    }
                )
            }
            .navigationBarItems(
                leading: HStack {
                    DropdownMenu()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            )
        }
    }
}


// Composants réutilisables
struct SectionTitle: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top)
    }
}

struct EmptyMessage: View {
    let text: String
    var body: some View {
        Text(text)
            .foregroundColor(.gray)
            .padding(.top)
    }
}

struct StyledButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}

struct GameListView: View {
    let games: [Game]
    let onSelect: (Game) -> Void
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(games) { game in
                    HStack {
                        Text(game.name)
                        Spacer()
                        Button(action: { onSelect(game) }) {
                            Text("Sélectionner")
                                .foregroundColor(.blue)
                                .padding(5)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .frame(height: min(CGFloat(games.count) * 44, CGFloat(3) * 44))
    }
}

struct GameDepositListView: View {
    let games: [GameLabel]
    let gameNames: [String: String]
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(games) { gameLabel in
                    HStack {
                        if let gameName = gameNames[gameLabel.gameId] {
                            Text(gameName)
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text("€ \(gameLabel.price, specifier: "%.2f")")
                            .foregroundColor(.gray)
                        Text(gameLabel.condition.rawValue)
                            .foregroundColor(gameLabel.condition == .new ? .green : .orange)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.bottom, 5)
                }
            }
        }
        .frame(maxHeight: 400)
    }
}



