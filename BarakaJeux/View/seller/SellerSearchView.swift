import SwiftUI

struct SellerSearchView: View {
    @StateObject private var viewModel = SearchSellerViewModel()
    @State private var selectedSeller: User?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                
                // Barre de recherche
                TextField("Rechercher un vendeur", text: $viewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 80)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 20)
                                .padding(.top, 80)
                        }
                    )

                // Lien "Nouveau vendeur"
                NavigationLink("Nouveau vendeur", destination: NewSellerView(onUpdate: {
                    viewModel.fetchSellers() } ))
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                
                
                

                Divider()
                
                // Liste des vendeurs
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.filteredSellers) { seller in
                                Button(action: {
                                    selectedSeller = seller
                                }) {
                                    ZStack {
                                        // Fond gris pour le vendeur sélectionné
                                        if selectedSeller?.id == seller.id {
                                            Color.gray.opacity(0.3)
                                                .cornerRadius(8)
                                        }
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("\(seller.firstname) \(seller.name)")
                                                    .fontWeight(.medium)
                                                Text(seller.email)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle()) // Pour éviter le style de bouton par défaut
                            }
                        }
                    }
                }

                // Bouton Déposer des jeux
                if selectedSeller != nil {
                    NavigationLink(destination: DepositView(seller: selectedSeller!)) {
                        Text("Déposer des jeux")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .padding()
                    
                    // Nouveau bouton "Voir son stock"
                    NavigationLink(destination: StockView(seller: selectedSeller!)) {
                        Text("Voir son stock")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .padding()

                    // Nouveau bouton "Voir ses rapports financiers"
                    NavigationLink(destination: FinancialReportView(seller: selectedSeller!)) {
                        Text("Voir ses rapports financiers")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .padding()
                }

                Spacer()
            }
            .navigationTitle("")
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
            // .navigationBarBackButtonHidden(true)
        }
    }
}

// Vue de prévisualisation
struct SellerSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SellerSearchView()
    }
}

