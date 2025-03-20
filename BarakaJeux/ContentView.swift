//
//  ContentView.swift
//  BarakaJeux
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Envelopper avec NavigationStack pour permettre la navigation
        NavigationStack {
            // Affiche la HomeView comme page d'accueil
            UserListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
