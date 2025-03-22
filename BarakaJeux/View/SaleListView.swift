//
//  EventListView.swift
//  BarakaJeux
//
//  Created by etud on 18/03/2025.
//

import SwiftUI


struct SaleListView: View {
    @StateObject private var viewModel = SaleListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Ventes")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                List(viewModel.sales) { sale in
                    NavigationLink(destination: SaleView(sale: sale, onUpdate: {
                        viewModel.fetchSales() } )) {
                        Text(sale.id ?? "ID non disponible")  // Si sale.id est nil, affiche "ID non disponible"
                    }
                }
                .listStyle(.insetGrouped)

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
}


struct SaleListView_Previews: PreviewProvider {
    static var previews: some View {
        SaleListView()
    }
}

