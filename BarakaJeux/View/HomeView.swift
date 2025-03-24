import SwiftUI

struct HomeView: View {
    

    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                
                Image("bannerTailleGrande")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 200)
                
                
                
                
                // Bouton seller
                NavigationLink(destination: SellerSearchView()) {
                    Text("SELLER")
                        .fontWeight(.bold)
                        .frame(width: 250, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                
                
                // Bouton buyer
                NavigationLink(destination: BuyView()) {
                    Text("BUYER")
                        .fontWeight(.bold)
                        .frame(width: 250, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            
                .padding(.top, 30)
                
                Spacer()
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
            .navigationBarTitle("")
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

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


