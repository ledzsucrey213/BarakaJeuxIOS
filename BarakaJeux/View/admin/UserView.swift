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
        NavigationStack {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(viewModel.user.firstname) \(viewModel.user.name)")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 40)

                    TextField("Prénom", text: $viewModel.user.firstname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Nom", text: $viewModel.user.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Email", text: $viewModel.user.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)

                    TextField("Adresse", text: $viewModel.user.address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Rôle", selection: $viewModel.user.role) {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            Text(role.rawValue.capitalized).tag(role)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical, 5)

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
                            .shadow(radius: 2)
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarItems(
                leading:
                    HStack {
                        DropdownMenu() // Menu à gauche
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
            )
        }
    }
}

