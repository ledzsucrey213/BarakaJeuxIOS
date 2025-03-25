import SwiftUI

struct SellerSearchView: View {
    @StateObject private var viewModel = SearchSellerViewModel()
    @State private var selectedSeller: User?

    var body: some View {
        NavigationView {
            ZStack {
                // Appliquer le même fond que HomeView
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Barre de recherche stylisée
                    HStack {
                        TextField("Rechercher un vendeur", text: $viewModel.searchQuery)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(15)
                            .shadow(radius: 3)
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .padding(.horizontal)
                    .padding(.top, 80)
                    
                    // Lien "Nouveau vendeur"
                    NavigationLink("Nouveau vendeur", destination: NewSellerView(onUpdate: {
                        viewModel.fetchSellers()
                    }))
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Liste des vendeurs sous forme de cartes
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(viewModel.filteredSellers) { seller in
                                    Button(action: {
                                        withAnimation {
                                            selectedSeller = seller
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.blue)
                                            
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
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(selectedSeller?.id == seller.id ? Color.gray.opacity(0.3) : Color.white)
                                                .shadow(radius: 3)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    
                    // Boutons d'actions pour le vendeur sélectionné
                    if let seller = selectedSeller {
                        VStack(spacing: 10) {
                            NavigationLink(destination: DepositView(seller: seller)) {
                                ActionButton(title: "Déposer des jeux")
                            }
                            NavigationLink(destination: StockView(seller: seller)) {
                                ActionButton(title: "Voir son stock")
                            }
                            NavigationLink(destination: FinancialReportView(seller: seller)) {
                                ActionButton(title: "Voir ses rapports financiers")
                            }
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("")
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

// Composant bouton stylisé
struct ActionButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

// Preview
struct SellerSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SellerSearchView()
    }
}

