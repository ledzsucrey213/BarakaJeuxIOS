import SwiftUI

struct PaymentModal: View {
    var price: Double
    var onPaymentSelected: (Payment) -> Void
    
    var body: some View {
        VStack {
            Text("Prix total: € \(price, specifier: "%.2f")")
                .font(.headline)
                .padding()
            
            HStack {
                Button(action: { onPaymentSelected(.cash) }) {
                    Text("Espèces")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                Button(action: { onPaymentSelected(.card) }) {
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

