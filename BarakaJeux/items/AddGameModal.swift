//
//  AddGameModal.swift
//  BarakaJeux
//
//  Created by etud on 16/03/2025.
//

import SwiftUI

struct AddGameModal: View {
    let game: Game?
    @Binding var price: String
    @Binding var condition: GameCondition
    var sellerid: String
    var onSave: (GameLabel) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ajouter le jeu")
                .font(.headline)
                .padding()

            // Nom du jeu (grisé)
            Text(game?.name ?? "Nom du jeu")
                .foregroundColor(.gray)
                .font(.title2)
                .padding()

            // Prix du jeu
            TextField("Prix", text: $price)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Condition du jeu
            Picker("Condition", selection: $condition) {
                Text("New").tag(GameCondition.new)
                Text("Very Good").tag(GameCondition.veryGood)
                Text("Good").tag(GameCondition.good)
                Text("Poor").tag(GameCondition.poor)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Bouton Valider
            Button("Valider") {
                if let game = game, let priceValue = Double(price) {
                    let gameLabel = GameLabel(
                        id: UUID().uuidString,
                        sellerId: sellerid,
                        gameId: game.id,
                        price: priceValue,
                        eventId: "",
                        condition: condition,
                        isSold: false,
                        creation: Date(),
                        isOnSale: true
                    )
                    onSave(gameLabel) // Ajouter le GameLabel à la liste
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .frame(width: 300)
    }
}
