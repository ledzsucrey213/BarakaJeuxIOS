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
                    NavigationLink("Evènements", destination: EventView())
                    NavigationLink("Utilisateurs", destination: UserView())
                    NavigationLink("Jeux", destination: GamesView())
                    NavigationLink("Rapports Financiers", destination: FinancialReportView(seller: viewModel.admin ?? User()))
                    NavigationLink("Stocks", destination: StockView(seller: viewModel.admin ?? User()))
                    NavigationLink("Ventes", destination: SalesView())
                }
                .listStyle(.insetGrouped)
            }
            .padding(.top, 70)
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

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
