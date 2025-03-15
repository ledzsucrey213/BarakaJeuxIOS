import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Image Bannière
            Image("banner") // Remplace "banner" par le nom de ton image dans Assets
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 200)

            // Texte de Bienvenue
            Text("Bienvenue au festival actuel")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // Champs de Texte
            VStack(spacing: 15) {
                TextField("Nom", text: $username)
                    .padding()
                    .frame(width: 300, height: 40)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                SecureField("Mot de passe", text: $password)
                    .padding()
                    .frame(width: 300, height: 40)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }

            // Bouton Connexion
            Button(action: {
                print("Connexion")
            }) {
                Text("CONNEXION")
                    .fontWeight(.bold)
                    .frame(width: 200, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

