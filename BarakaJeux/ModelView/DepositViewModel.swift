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
            // Lorsqu'il y a un changement dans searchText, on met à jour la vue
            updateFilteredGames()
        }
    }
    @Published var showGameList: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let sellerID: String
    
    // Liste filtrée des jeux
    @Published var filteredAvailableGames: [Game] = []
    
    // Dictionnaire gameNames pour stocker les noms de jeux associés aux gameId
        var gameNames: [String: String] = [:]
    
    init(sellerID: String) {
        self.sellerID = sellerID
    }

    func fetchAvailableGames() {
        guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game") else { return }

        print("📡 Appel API pour récupérer les jeux disponibles...")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> Data in
                print("✅ Données brutes reçues : \(String(data: data, encoding: .utf8) ?? "Non lisible")")
                return data
            }
            .decode(type: [Game].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Erreur lors du chargement des jeux disponibles : \(error)")
                }
            }, receiveValue: { [weak self] games in
                print("🎯 Jeux décodés : \(games.map { $0.name })")
                self?.availableGames = games
                self?.updateFilteredGames() // Met à jour les jeux filtrés dès que la liste des jeux est récupérée
            })
            .store(in: &cancellables)
    }

    func fetchDepositedGames() {
            guard let url = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game_label/seller/\(sellerID)") else { return }

            print("📡 Appel API pour récupérer les jeux déposés...")

            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: [GameLabel].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ Erreur lors du chargement des jeux déposés : \(error)")
                    }
                }, receiveValue: { [weak self] gameLabels in
                    var updatedGameLabels: [GameLabel] = []
                    
                    let group = DispatchGroup()

                    // Pour chaque GameLabel, on récupère le jeu correspondant via son gameId
                    for gameLabel in gameLabels {
                        group.enter()

                        guard let gameUrl = URL(string: "http://barakajeuxbackend.cluster-ig4.igpolytech.fr/api/game/\(gameLabel.gameId)") else {
                            group.leave()
                            continue
                        }

                        URLSession.shared.dataTaskPublisher(for: gameUrl)
                            .map { data, response -> Data in
                                print("✅ Données du jeu avec gameId : \(gameLabel.gameId) reçues.")
                                return data
                            }
                            .decode(type: Game.self, decoder: JSONDecoder())
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    print("❌ Erreur lors du chargement du jeu pour gameId \(gameLabel.gameId) : \(error)")
                                }
                            }, receiveValue: { game in
                                // Associer gameId au nom du jeu dans le dictionnaire
                                self?.gameNames[gameLabel.gameId] = game.name
                                group.leave()
                            })
                            .store(in: &self!.cancellables)
                    }

                    // Attente que toutes les requêtes soient terminées
                    group.notify(queue: .main) {
                        // Ajouter le nom du jeu dans chaque GameLabel en utilisant le dictionnaire gameNames
                        for gameLabel in gameLabels {
                            if let gameName = self?.gameNames[gameLabel.gameId] {
                                // Ajouter le nom du jeu au GameLabel sous forme de tuple
                                updatedGameLabels.append(gameLabel)
                            }
                        }
                        
                        self?.depositedGames = updatedGameLabels
                        print("🎯 Liste des jeux déposés mise à jour avec les noms des jeux.")
                    }
                })
                .store(in: &cancellables)
        }
    
    
    // Fonction pour ajouter un jeu à la liste des jeux à déposer
        func addGameToDeposit(_ gameLabel: GameLabel) {
            // Ajouter le jeu à la liste des jeux à déposer
            self.gamesToDeposit.append(gameLabel)
            print("🎯 Jeu ajouté à la liste des jeux à déposer : \(gameLabel)")
        }
    
    
    // Méthode pour mettre à jour la liste filtrée
    private func updateFilteredGames() {
        if searchText.isEmpty {
            filteredAvailableGames = availableGames
        } else {
            filteredAvailableGames = availableGames.filter { game in
                game.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
