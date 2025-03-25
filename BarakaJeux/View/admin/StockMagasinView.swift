import SwiftUI

struct StockMagasinView: View {
    @StateObject private var viewModel: StockViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: StockViewModel(sellerID: "675c75c5cd3b594a7528034f"))
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





