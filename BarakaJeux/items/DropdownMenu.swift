import SwiftUI

// Le menu déroulant avec des options
struct DropdownMenu: View {
    var body: some View {
        Menu {
            
            Button(action: {
                // Action pour "Report"
                print("seller clicked")
            }) {
                Text("Seller")
            }
            Button(action: {
                // Action pour "Report"
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
                .foregroundColor(.blue) // Tu peux changer la couleur ici
        }
    }
}
