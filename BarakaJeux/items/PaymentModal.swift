//
//  PaymentModal.swift
//  BarakaJeux
//
//  Created by etud on 16/03/2025.
//

import SwiftUI

struct PaymentModal: View {
    var price: Double
    var onPaymentSelected: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Prix total: € \(price, specifier: "%.2f")")
                .font(.headline)
                .padding()
            
            HStack {
                Button(action: { onPaymentSelected("Espèces") }) {
                    Text("Espèces")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                Button(action: { onPaymentSelected("Carte") }) {
                    Text("Carte")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}
