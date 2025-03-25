import SwiftUI

struct AdminView: View {
    @StateObject private var viewModel = AdminViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fond dégradé pour toute la page
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Page Administrateur")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 20)
                        .padding(.leading, 20)

                    List {
                        NavigationLink("Evènements", destination: EventListView())
                        NavigationLink("Utilisateurs", destination: UserListView())
                        NavigationLink("Jeux", destination: GamesListView())
                        NavigationLink("Rapport global", destination: ReportMagasinView())
                        NavigationLink("Stock du magasin", destination: StockMagasinView())
                        NavigationLink("Ventes", destination: SaleListView())
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear) // Assurez-vous que le fond est transparent pour que le fond dégradé soit visible derrière la liste
                }
                .padding(.top, 70)
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

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}

