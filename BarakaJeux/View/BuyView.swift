import SwiftUI

struct BuyView: View {
    @StateObject private var viewModel: BuyViewModel
    @State private var selectedGame: GameLabel? = nil  // Pour stocker le jeu sélectionné
    @State private var showPaymentModal = false   // Afficher la fenêtre modale de paiement
    @State private var showSuccessView = false    // Afficher la vue de succès

    init() {
        _viewModel = StateObject(wrappedValue: BuyViewModel())
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Achat de jeux")
                    .font(.title)
                    .bold()
                    .padding(.top, 40)

                SearchBar(text: $viewModel.searchText)

                Text("Jeux disponibles")
                    .font(.headline)
                    .padding(.top)

                if !viewModel.filteredAvailableGames.isEmpty {
                    List(viewModel.filteredAvailableGames) { game in
                        HStack {
                            Text(viewModel.gameNames[game.gameId] ?? "Nom inconnu")
                                .font(.headline)

                            Spacer()

                            Text("€ \(game.price, specifier: "%.2f")")
                                .foregroundColor(.gray)

                            Text(game.condition.rawValue)
                                .foregroundColor(game.condition == .new ? .green : .orange)

                            Button(action: {
                                viewModel.gamesInCart.append(game)
                            }) {
                                Text("Ajouter")
                                    .foregroundColor(.blue)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .frame(minHeight: 60, maxHeight: CGFloat(viewModel.filteredAvailableGames.count * 44))
                } else {
                    Text("Aucun jeu trouvé pour cette recherche.")
                        .foregroundColor(.gray)
                        .padding(.top)
                }

                Text("Jeux dans le panier")
                    .font(.headline)
                    .padding(.top)

                if !viewModel.gamesInCart.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.gamesInCart) { gameLabel in
                                HStack {
                                    Text(viewModel.gameNames[gameLabel.gameId] ?? "Nom inconnu")
                                        .font(.subheadline)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)

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
                } else {
                    Text("Aucun jeu dans le panier")
                        .foregroundColor(.gray)
                        .padding(.top)
                }

                Button(action: {
                    self.showPaymentModal.toggle()
                }) {
                    Text("Acheter")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: SuccessPurchaseView(), isActive: $showSuccessView) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
            .onAppear {
                viewModel.fetchAvailableGames()
            }
            .sheet(isPresented: $showPaymentModal) {
                PaymentModal(price: viewModel.coutTotal()) { paymentMethod in
                    viewModel.endPurchase(paymentMethod: paymentMethod)
                    self.showPaymentModal = false
                    self.showSuccessView = true
                }
            }
            .navigationBarItems(
                leading:
                    HStack {
                        DropdownMenu()
                        Spacer()
                        Image("banner")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.leading, 10)
                            .offset(y: 20)
                    }
                    .frame(maxWidth: .infinity)
            )
        }
    }
}

