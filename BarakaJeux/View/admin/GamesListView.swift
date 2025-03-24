//
//  EventListView.swift
//  BarakaJeux
//
//  Created by etud on 18/03/2025.
//

import SwiftUI


struct GamesListView: View {
    @StateObject private var viewModel = GameListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Jeux")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                List(viewModel.games) { game in
                    NavigationLink(destination: GameView(game: game, onUpdate: {
                        viewModel.fetchGames() } )) {
                        Text(game.name)
                    }
                }
                .listStyle(.insetGrouped)
                
                .onAppear {
                    viewModel.fetchGames()  // Charger les événements dès que la vue apparaît
                }


                Button(action: {
                    let newGame = GameToSubmit(name: "Nouveau Jeu", editor: "Éditeur", description: "Description du jeu", count: 1)
                    viewModel.createGame(game: newGame)
                }) {
                    Text("Ajouter un jeu")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
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
}


struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView()
    }
}

