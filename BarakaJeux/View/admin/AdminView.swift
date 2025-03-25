import SwiftUI

struct AdminView: View {
    @StateObject private var viewModel = AdminViewModel()
    
    @State private var isUnlocked = false
    @State private var enteredCode = ""
    @State private var showAlert = true
    @State private var showError = false

    var body: some View {
        NavigationStack {
            if isUnlocked {
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
                        .background(Color.clear) // Fond transparent
                    }
                    .padding(.top, 70)
                }
                .navigationBarItems(
                    leading:
                        HStack {
                            DropdownMenu() // Menu à gauche
                            Spacer()
                        }
                        .frame(maxWidth: .infinity) // Meilleur positionnement
                )
            }
        }
        .onAppear {
            showAlert = true // Afficher le popup dès l'apparition de la vue
        }
        .alert("Entrez le code administrateur", isPresented: $showAlert) {
            VStack {
                SecureField("Code", text: $enteredCode)
                Button("Valider") {
                    if enteredCode == "barakajeux" {
                        isUnlocked = true
                        showAlert = false
                    } else {
                        showError = true
                        enteredCode = ""
                    }
                }
            }
        }
        .alert("Code incorrect", isPresented: $showError) {
            Button("Réessayer") {
                showAlert = true
            }
        }
    }
}



