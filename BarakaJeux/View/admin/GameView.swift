import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    var onUpdate: (() -> Void)?

    init(game: Game, onUpdate: (() -> Void)? = nil) {
        self.onUpdate = onUpdate
        _viewModel = StateObject(wrappedValue: GameViewModel(game: game))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Fond dégradé pour toute la page
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.game.name)
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 40)

                        TextField("Nom", text: $viewModel.game.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Editeur", text: $viewModel.game.editor)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextEditor(text: $viewModel.game.description)
                            .frame(height: 150) // Ajuste la hauteur pour plus de confort
                            .border(Color.gray, width: 1) // Ajoute une bordure pour plus de visibilité
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.bottom, 10)

                        Button(action: {
                            viewModel.updateGame()
                            onUpdate?()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Sauvegarder")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
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



