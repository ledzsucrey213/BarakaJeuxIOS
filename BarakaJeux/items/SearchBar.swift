import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Rechercher un nom de jeu", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)


            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

