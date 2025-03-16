import SwiftUI


struct DropdownMenu: View {
    @State private var navigateToSeller = false // état pour gérer la navigation vers Seller
    
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
                print("Buyer clicked")
            }) {
                Text("Buyer")
            }
            
            Button(action: {
                // Action pour "Report"
                print("Report clicked")
            }) {
                Text("Report")
            }
            
            Button(action: {
                // Action pour "Invoice"
                print("Invoice clicked")
            }) {
                Text("Invoice")
            }
            
            Button(action: {
                // Action pour "Stock"
                print("Stock clicked")
            }) {
                Text("Stock")
            }
        } label: {
            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
        }
        
        // Ajouter un NavigationLink explicite qui sera activé par l'état
        NavigationLink(destination: SellerSearchView(), isActive: $navigateToSeller) {
            EmptyView() // On ne veut rien afficher ici, mais il y a une navigation cachée

        }
            }
        }
