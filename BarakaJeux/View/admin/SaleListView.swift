import SwiftUI

struct SaleListView: View {
    @StateObject private var viewModel = SaleListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack {
                    Text("Ventes")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 40)

                    List(viewModel.sales) { sale in
                        NavigationLink(destination: SaleView(sale: sale, onUpdate: {
                            viewModel.fetchSales()
                        })) {
                            Text("\(formattedDate(sale.dateOfSale))")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear) // Permet d'afficher le fond dégradé derrière la liste
                    
                }
                .padding()
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
        }
    }
}

// Formate la date proprement
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

