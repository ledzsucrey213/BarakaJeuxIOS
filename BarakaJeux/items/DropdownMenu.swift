import SwiftUI


struct DropdownMenu: View {
    @State private var navigateToSeller = false // état pour gérer la navigation vers Seller
    @State private var navigateToBuyer = false // état pour gérer la navigation vers Buyer
    @State private var navigateToAdmin = false // état pour gérer la navigation vers Seller
    @State private var navigateToBuy = false // état pour gérer la navigation vers Buyer

    
    var body: some View {
        Menu {
            Button(action: {
                // Mettre l'état à true pour activer la navigation
                navigateToSeller = true
            }) {
                Text("Seller")
            }
            
            Button(action: {
                // Action pour "Buyer"
                navigateToBuy = true
            }) {
                Text("Buyer")
            }
            
            
            Button(action: {
                // Action pour "Invoice"
                navigateToBuyer = true
            }) {
                Text("Invoice")
            }
            
            Button(action: {
                // Action pour "Stock"
                navigateToAdmin = true
            }) {
                Text("Admin")
            }
        } label: {
            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.blue)
        }
        
        // Ajouter un NavigationLink explicite qui sera activé par l'état
        NavigationLink(destination: SellerSearchView(), isActive: $navigateToSeller) {
            EmptyView() // On ne veut rien afficher ici, mais il y a une navigation cachée

        }
        
        NavigationLink(destination: BuyView(), isActive: $navigateToBuy) {
            EmptyView() // On ne veut rien afficher ici, mais il y a une navigation cachée

        }
        
        // Ajouter un NavigationLink explicite qui sera activé par l'état
        NavigationLink(destination: AdminView(), isActive: $navigateToAdmin) {
            EmptyView() // On ne veut rien afficher ici, mais il y a une navigation cachée

        }
        
        NavigationLink(destination: BuyerListView(), isActive: $navigateToBuyer) {
            EmptyView() // On ne veut rien afficher ici, mais il y a une navigation cachée

        }
        

            }
        }
