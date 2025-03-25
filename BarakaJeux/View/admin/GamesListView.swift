import SwiftUI

struct GamesListView: View {
    @StateObject private var viewModel = GameListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("🎮 Jeux")
                            .font(.title)
                            .bold()
                            .padding(.top, 40)

                        ForEach(viewModel.games) { game in
                            GameListCard(game: game, onUpdate: {
                                viewModel.fetchGames()
                            })
                        }

                        Button(action: {
                            let newGame = GameToSubmit(name: "Nouveau Jeu", editor: "Éditeur", description: "Description du jeu", count: 1)
                            viewModel.createGame(game: newGame)
                        }) {
                            Text("➕ Ajouter un jeu")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .onAppear {
                viewModel.fetchGames()
            }
            .navigationBarItems(
                leading:
                    HStack {
                        DropdownMenu() // Menu à gauche
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
            )
        }
    }
}

// Composant de carte jeu
struct GameListCard: View {
    let game: Game
    var onUpdate: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🎲 \(game.name)")
                .font(.headline)

            Text("🏢 Éditeur: \(game.editor)")
                .font(.subheadline)

            NavigationLink(destination: GameView(game: game, onUpdate: onUpdate)) {
                Text("🔍 Consulter")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView()
    }
}

