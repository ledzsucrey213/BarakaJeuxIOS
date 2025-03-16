//
//  DepositView.swift
//  BarakaJeux
//
//  Created by etud on 15/03/2025.
//

import SwiftUI


struct DepositView: View {
    let seller: User

    var body: some View {
        VStack {
            Text("Déposer des jeux pour \(seller.firstname) \(seller.name)")
                .font(.title2)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Déposer des jeux")
    }
}


struct DepositView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            id: "1",
            firstname: "Jean",
            name: "Dupont",
            email: "jean.dupont@example.com",
            address: "123 Rue de Paris",
            role: .seller
        )

        return DepositView(seller: sampleUser)
    }
}

