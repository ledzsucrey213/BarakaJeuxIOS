import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            HomeView()
        } else {
            VStack(spacing: 20) {
                Image("bannerTailleGrande")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 200)
                
                Text("Bienvenue au festival actuel")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 15) {
                    TextField("Nom", text: $viewModel.username)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    SecureField("Mot de passe", text: $viewModel.password)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    viewModel.login()
                }) {
                    Text("CONNEXION")
                        .fontWeight(.bold)
                        .frame(width: 200, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
