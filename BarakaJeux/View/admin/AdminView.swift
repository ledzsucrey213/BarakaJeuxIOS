import SwiftUI

struct AdminView: View {
    @StateObject private var viewModel = AdminViewModel()
    
    // Utilisation de @AppStorage pour conserver l'état de "déverrouillage"
    @AppStorage("isAdminUnlocked") private var isUnlocked = false
    @State private var enteredCode = ""
    @State private var showAlert = true
    @State private var showError = false
    @State private var isNavigatingFromDropdown = false // Variable pour savoir si on vient du dropdown

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
            if !isNavigatingFromDropdown {
                showAlert = false // Ne pas montrer l'alerte si on vient du bouton back
            } else {
                showAlert = true // Afficher l'alerte si on navigue depuis le dropdown
            }
        }
        .onChange(of: isUnlocked) { _ in
            // Lorsque l'utilisateur est déverrouillé, ne plus afficher l'alerte.
            if isUnlocked {
                showAlert = false
            }
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
        .onDisappear {
            // Lorsque la vue disparaît, on réinitialise isNavigatingFromDropdown à false
            isNavigatingFromDropdown = false
        }
        .navigationBarItems(trailing: Button(action: {
            // Si on vient du dropdown, on marque isNavigatingFromDropdown comme vrai
            isNavigatingFromDropdown = true
        }) {
            Text("Retour")
        })
    }
}

