//
//  SuccessView.swift
//  BarakaJeux
//
//  Created by etud on 16/03/2025.
//

import SwiftUI

struct SuccessView: View {
    var onReturnToHome: () -> Void
    
    var body: some View {
        VStack {
            Text("Merci pour votre dépôt !")
                .font(.title)
                .padding()
            
            Button(action: onReturnToHome) {
                Text("Revenir vers l'accueil")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

