import SwiftUI

struct HomeView: View {
    

    var body: some View {
        VStack(spacing: 20) {
            // Image Bannière
            Image("banner") // Remplace "banner" par le nom de ton image dans Assets
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 200)

                

            // Bouton seller
            Button(action: {
                print("Seller")
            }) {
                Text("SELLER")
                    .fontWeight(.bold)
                    .frame(width: 200, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 60)
            
            
            // Bouton buyer
            Button(action: {
                print("Buyer")
            }) {
                Text("BUYER")
                    .fontWeight(.bold)
                    .frame(width: 200, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            .padding(.top, 40)

            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


