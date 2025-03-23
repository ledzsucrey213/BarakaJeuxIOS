import SwiftUI

struct SuccessPurchaseView: View {
    @State private var navigateToHome = false // Variable pour contrôler la navigation

    var body: some View {
        NavigationStack {
            VStack {
                Text("Merci pour votre achat !")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    navigateToHome = true
                }) {
                    Text("Revenir vers l'accueil")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(destination: HomeView()
                    .navigationBarBackButtonHidden(true),
                    isActive: $navigateToHome
                ) {
                    EmptyView()
                }
            }
        }
    }
}


