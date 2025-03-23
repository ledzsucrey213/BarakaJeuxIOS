import SwiftUI

struct AdminView: View {
    @StateObject private var viewModel = AdminViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Page Administrateur")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                List {
                    NavigationLink("Evènements", destination: EventListView())
                    NavigationLink("Utilisateurs", destination: UserListView())
                    NavigationLink("Jeux", destination: GamesListView())
                    NavigationLink("Rapport global", destination: FinancialReportView(seller: viewModel.admin ?? User()))
                    NavigationLink("Stock du magasin", destination: StockMagasinView())
                    NavigationLink("Ventes", destination: SaleListView())
                }
                .listStyle(.insetGrouped)
            }
            .padding(.top, 70)
            .navigationBarItems(
                            leading:
                                HStack {
                                    DropdownMenu() // Menu à gauche
                                    Spacer()
                                    Image("banner")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit) // Garde l'aspect de l'image
                                        .frame(height: 70)
                                        .padding(.leading, 10)
                                        .padding(.top, 20)
                                    Spacer()

                                }
                                .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
                        )
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
