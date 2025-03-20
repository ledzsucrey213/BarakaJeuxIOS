import SwiftUI

struct DepositView: View {
    @StateObject private var viewModel: DepositViewModel
    let seller: User
    @State private var selectedGame: Game? = nil  // Pour stocker le jeu sélectionné
    @State private var price: String = ""         // Prix du jeu à entrer
    @State private var condition: GameCondition = .new // Condition du jeu
    @State private var showAddGameModal = false   // Afficher ou non la fenêtre modale
    @State private var showPaymentModal = false   // Afficher la fenêtre modale de paiement
    @State private var showSuccessView = false    // Afficher la vue de succès

    init(seller: User) {
        self.seller = seller
        _viewModel = StateObject(wrappedValue: DepositViewModel(sellerID: seller.id ?? ""))
    }

    var body: some View {
        NavigationView { // Ajouter NavigationView pour la gestion de la navigation
            VStack(alignment: .leading) {
                Text("Dépôt de jeux")
                    .font(.title)
                    .bold()
                    .padding(.top, 40)
                
                SearchBar(text: $viewModel.searchText)
                
                Text("Jeux disponibles")
                    .font(.headline)
                    .padding(.top)

                // Afficher la liste des jeux filtrés, seulement si la recherche contient du texte
                if !viewModel.searchText.isEmpty {
                    List(viewModel.filteredAvailableGames) { game in
                        HStack {
                            Text(game.name)
                            Spacer()
                            Button(action: {
                                self.selectedGame = game
                                self.showAddGameModal.toggle()
                            }) {
                                Text("Sélectionner")
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
                
                Text("Jeux à déposer")
                    .font(.headline)
                    .padding(.top)

                if !viewModel.gamesToDeposit.isEmpty { // Vérifie si la liste des jeux à déposer n'est pas vide
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.gamesToDeposit) { gameLabel in
                                HStack {
                                    if let gameName = viewModel.gameNames[gameLabel.gameId] {
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
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .padding(.bottom, 5)
                            }
                        }
                        .padding(.top, 5)
                    }
                    .frame(maxHeight: 400)
                } else {
                    Text("Aucun jeu à déposer")
                        .foregroundColor(.gray)
                        .padding(.top)
                }


                Button(action: {
                    // Calculer le prix total et afficher le modal de paiement
                    self.showPaymentModal.toggle()
                }) {
                    Text("DÉPOSER")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text("Jeux déposés")
                    .font(.headline)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack {
                        // Affichage de tous les jeux déposés
                        ForEach(viewModel.depositedGames) { gameLabel in
                            HStack {
                                if let gameName = viewModel.gameNames[gameLabel.gameId] {
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
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.bottom, 5)
                        }
                    }
                    .padding(.top, 5)
                }
                .frame(maxHeight: 400)
                
                // NavigationLink pour la vue SuccessView
                NavigationLink(destination: SuccessView(), isActive: $showSuccessView) {
                    EmptyView() // Cela rend le NavigationLink invisible
                }
                .hidden() // Cacher le lien de navigation
            }
            .padding()
            .onAppear {
                viewModel.fetchDepositedGames()
                viewModel.fetchAvailableGames()
            }
            .sheet(isPresented: $showAddGameModal) {
                // Fenêtre modale pour ajouter un jeu
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
                // Fenêtre modale de paiement
                PaymentModal(price: viewModel.coutTotal()) { paymentMethod in
                    // Lancer la fonction `endDeposit()` avec le mode de paiement
                    viewModel.endDeposit()
                    self.showPaymentModal = false
                    self.showSuccessView = true // Afficher SuccessView après le dépôt
                }
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

struct DepositView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            id: "1",
            firstname: "Jean",
            name: "Dupont",
            email: "jean.dupont@example.com",
            address: "123 Rue de Paris",
            role: .seller
        )

        return DepositView(seller: sampleUser)
    }
}

