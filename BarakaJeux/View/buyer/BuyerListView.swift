import SwiftUI

struct BuyerListView: View {
    @StateObject private var viewModel = BuyerListViewModel()
    @State private var selectedBuyer: User?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                
                // Barre de recherche
                TextField("Rechercher un client", text: $viewModel.searchQuery)
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
                
                
                

                Divider()
                
                // Liste des clients
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    List(viewModel.filteredBuyers) { buyer in
                        Button(action: {
                            selectedBuyer = buyer
                        }) {
                            ZStack {
                                // Fond gris pour le vendeur sélectionné
                                if selectedBuyer?.id == buyer.id {
                                    Color.gray.opacity(0.3)
                                        .cornerRadius(8)
                                }
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(buyer.firstname) \(buyer.name)")
                                            .fontWeight(.medium)
                                        Text(buyer.email)
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

                // Bouton Déposer des jeux
                if selectedBuyer != nil {
                    NavigationLink(destination: InvoiceListView(buyer: selectedBuyer!)) {
                        Text("Voir ses factures")
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

                                        }
                                        .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
                                )
            // .navigationBarBackButtonHidden(true)
        }
    }
}

