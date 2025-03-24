//
//  EventView.swift
//  BarakaJeux
//
//  Created by etud on 16/03/2025.
//

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
        VStack(alignment: .leading, spacing: 20) {
            Text("\(viewModel.game.name)")
                .font(.largeTitle)
                .bold()

            TextField("Nom", text: $viewModel.game.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Editeur", text: $viewModel.game.editor)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextEditor(text: $viewModel.game.description)
                .frame(height: 150) // Ajuste la hauteur pour plus de confort
                .border(Color.gray, width: 1) // Ajoute une bordure pour plus de visibilité
                .cornerRadius(8)
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
            }
            
            .navigationBarItems(
                                    leading:
                                        HStack {
                                            DropdownMenu() // Menu à gauche
                                            Spacer()

                                        }
                                        .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
                                )

            Spacer()
        }
        .padding()
    }
}



