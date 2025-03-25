//
//  DepositViewModel.swift
//  BarakaJeux
//
//  Created by etud on 16/03/2025.
//

import Foundation
import SwiftUI
import Combine

class DepositViewModel: ObservableObject {
    @Published var availableGames: [Game] = []
    @Published var depositedGames: [GameLabel] = []
    @Published var gamesToDeposit: [GameLabel] = []
    @Published var searchText: String = "" {
        didSet {
            updateFilteredGames()
        }
    }
    @Published var showGameList: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let sellerID: String
    
    // Liste filtrée des jeux
    @Published var filteredAvailableGames: [Game] = []
    
    // Dictionnaire gameNames pour stocker les noms des jeux associés aux gameId
    var gameNames: [String: String] = [:]
    
    init(sellerID: String) {
        self.sellerID = sellerID
        UITextField.appearance().inputAssistantItem.leadingBarButtonGroups = []
        UITextField.appearance().inputAssistantItem.trailingBarButtonGroups = []
    }

    func fetchAvailableGames() {
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game") else { return }

        print("📡 [API] Récupération des jeux disponibles...")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> Data in
                print("✅ [Réponse] Données brutes reçues : \(String(data: data, encoding: .utf8) ?? "Non lisible")")
                return data
            }
            .decode(type: [Game].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ [Erreur] Chargement des jeux disponibles : \(error)")
                }
            }, receiveValue: { [weak self] games in
                print("🎯 [Succès] Jeux disponibles : \(games.map { $0.name })")
                self?.availableGames = games
                self?.updateFilteredGames()
            })
            .store(in: &cancellables)
    }

    func fetchDepositedGames() {
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label/seller/\(sellerID)") else { return }

        print("📡 [API] Récupération des jeux déposés...")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> Data in
                print("📥 [Réponse] JSON reçu : \(String(data: data, encoding: .utf8) ?? "Non lisible")")
                return data
            }
            .decode(type: [GameLabel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ [Erreur] Chargement des jeux déposés : \(error)")
                }
            }, receiveValue: { [weak self] gameLabels in
                print("🎯 [Succès] Jeux déposés récupérés : \(gameLabels)")

                var updatedGameLabels: [GameLabel] = []
                let group = DispatchGroup()

                for gameLabel in gameLabels {
                    group.enter()
                    guard let gameUrl = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game/\(gameLabel.gameId)") else {
                        group.leave()
                        continue
                    }

                    URLSession.shared.dataTaskPublisher(for: gameUrl)
                        .map { data, response -> Data in
                            //print("✅ [Réponse] Détails du jeu (\(gameLabel.gameId)) reçus.")
                            return data
                        }
                        .decode(type: Game.self, decoder: JSONDecoder())
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                print("❌ [Erreur] Chargement du jeu (\(gameLabel.id)) : \(error)")
                            }
                        }, receiveValue: { game in
                            self?.gameNames[gameLabel.gameId] = game.name
                            group.leave()
                        })
                        .store(in: &self!.cancellables)
                }

                group.notify(queue: .main) {
                    for gameLabel in gameLabels {
                        updatedGameLabels.append(gameLabel)
                        print("📌 [Info] Jeu déposé : \(gameLabel.gameId) | \(self?.gameNames[gameLabel.gameId] ?? "Nom inconnu") | \(gameLabel.price)€")
                    }

                    self?.depositedGames = updatedGameLabels
                    print("🎯 [Mise à jour] Liste des jeux déposés finalisée.")
                    
                    print("💰 [Prix des jeux déposés] :")
                        self?.depositedGames.forEach { gameLabel in
                            print("🔹 Jeu ID: \(gameLabel.gameId) | Prix: \(gameLabel.price)€")
                        }
                    
                    // Print the contents of depositedGames after updating
                    print("📋 [Liste des jeux déposés] : \(self?.depositedGames ?? [])")
                }
            })
            .store(in: &cancellables)
    }
    
    
    
    func addGameToDeposit(_ gameLabel: GameLabel) {
        gamesToDeposit.append(gameLabel)
        print("➕ [Ajout] Jeu ajouté à la liste des jeux à déposer : \(gameLabel)")
    }

    private func updateFilteredGames() {
        if searchText.isEmpty {
            filteredAvailableGames = availableGames
        } else {
            filteredAvailableGames = availableGames.filter { game in
                game.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func endDeposit() {
        print("📤 [Début] Dépôt des jeux en cours...")

        let gameLabelsToSubmit = gamesToDeposit.map { gameLabel -> GameLabelToSubmit in
            GameLabelToSubmit(
                sellerId: gameLabel.sellerId,
                gameId: gameLabel.gameId,
                price: gameLabel.price,
                eventId: gameLabel.eventId,
                condition: gameLabel.condition,
                isSold: gameLabel.isSold,
                isOnSale: gameLabel.isOnSale,
                depositFee: gameLabel.deposit_fee
            )
        }

        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label/deposit") else {
            print("❌ [Erreur] URL invalide.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let data = JSONHelper.encode(object: gameLabelsToSubmit) else {
            print("❌ [Erreur] Encodage des données JSON.")
            return
        }

        if let jsonString = String(data: data, encoding: .utf8) {
            print("📤 [Requête] Données envoyées : \(jsonString)")
        }

        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [Erreur] Requête échouée : \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("❌ [Erreur] Réponse serveur invalide.")
                return
            }

            DispatchQueue.main.async {
                self.gamesToDeposit.removeAll()
                print("✅ [Succès] Dépôt des jeux effectué avec succès.")
            }
        }.resume()
    }

    func coutTotal() -> Double {
        let total = 0.05 * gamesToDeposit.reduce(0) { $0 + $1.price }
        print("💰 [Calcul] Total du dépôt : \(total)€")
        return total
    }
}

