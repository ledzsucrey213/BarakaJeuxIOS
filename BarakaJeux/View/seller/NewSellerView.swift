import SwiftUI

struct NewSellerView: View {
    @StateObject private var viewModel = NewSellerViewModel()
    @Environment(\.presentationMode) var presentationMode
    var onUpdate: (() -> Void)?

    init(onUpdate: (() -> Void)? = nil) {
        self.onUpdate = onUpdate
        _viewModel = StateObject(wrappedValue: NewSellerViewModel())
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Créer un Vendeur")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 40)

                        CustomTextField(title: "Prénom", text: $viewModel.firstname)
                        CustomTextField(title: "Nom", text: $viewModel.name)
                        CustomTextField(title: "Email", text: $viewModel.email, keyboardType: .emailAddress)

                        Text("Adresse")
                            .font(.headline)
                            .foregroundColor(.gray)

                        TextEditor(text: $viewModel.address)
                            .frame(height: 150)
                            .padding(8)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 2)

                        Button(action: {
                            viewModel.createSeller {
                                onUpdate?()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Créer le vendeur")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
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

// Composant personnalisé pour les champs de texte
struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(keyboardType)
                .padding(8)
                .background(Color.white.opacity(0.9))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}

