import SwiftUI

// Définition d'une couleur personnalisée "LightBlue"
extension Color {
    static let lightBlue = Color(red: 5/255, green: 56/255, blue: 146/255) // Bleu clair
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Dégradé de fond
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    
                    // Logo amélioré avec ombre
                    Image("bannerTailleGrande")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .shadow(radius: 5)

                    // Boutons avec animation et effet moderne
                    VStack(spacing: 15) {
                        CustomButton(title: "SELLER", destination: SellerSearchView())
                        CustomButton(title: "BUYER", destination: BuyView())
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
            }
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

// Composant réutilisable pour les boutons stylisés
struct CustomButton<Destination: View>: View {
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .frame(width: 250, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue) // Bleu clair appliqué ici
                        .shadow(radius: 5) // Effet d'ombre
                )
                .foregroundColor(.white)
                .scaleEffect(1.0)
                .animation(.spring(), value: 1.0)
        }
        .buttonStyle(PlainButtonStyle()) // Évite les effets par défaut
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

