//
//  UserView.swift
//  BarakaJeux
//
//  Created by etud on 16/03/2025.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    var onUpdate: (() -> Void)?

    init(user: User, onUpdate: (() -> Void)? = nil) {
        self.onUpdate = onUpdate
        _viewModel = StateObject(wrappedValue: UserViewModel(user: user))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(viewModel.user.firstname) \(viewModel.user.name)")
                .font(.largeTitle)
                .bold()

            TextField("Prénom", text: $viewModel.user.firstname)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nom", text: $viewModel.user.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $viewModel.user.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)

            TextField("Adresse", text: Binding(
                get: { viewModel.user.address ?? "" },
                set: { viewModel.user.address = $0.isEmpty ? nil : $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Rôle", selection: $viewModel.user.role) {
                ForEach(UserRole.allCases, id: \.self) { role in
                    Text(role.rawValue.capitalized).tag(role)
                }
            }
            .pickerStyle(MenuPickerStyle()) // Ajoute un menu déroulant propre


            Button(action: {
                viewModel.updateUser()
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

            Spacer()
        }
        .padding()
    }
}

