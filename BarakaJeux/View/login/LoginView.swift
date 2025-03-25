import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            HomeView()
        } else {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("banner-removebg-preview")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 500, maxHeight: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    Text("Bienvenue au festival actuel")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)

                    VStack(spacing: 15) {
                        CustomLoginTextField(placeholder: "Nom", text: $viewModel.username)
                        CustomLoginTextField(placeholder: "Mot de passe", text: $viewModel.password, isSecure: true)
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top, 5)
                    }

                    Button(action: {
                        viewModel.login()
                    }) {
                        Text("CONNEXION")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .frame(width: 220)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

// Composant de champ de texte personnalisé
struct CustomLoginTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .textFieldStyle()
        } else {
            TextField(placeholder, text: $text)
                .textFieldStyle()
        }
    }
}

// Extension pour styliser les champs de texte
extension View {
    func textFieldStyle() -> some View {
        self
            .padding()
            .frame(height: 50)
            .background(Color.white.opacity(0.9))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            .shadow(radius: 2)
            .padding(.horizontal, 20)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

