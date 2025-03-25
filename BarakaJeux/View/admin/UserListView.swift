import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack {
                    Text("Utilisateurs")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 40)

                    List(viewModel.users) { user in
                        NavigationLink(destination: UserView(user: user, onUpdate: {
                            viewModel.fetchUsers()
                        })) {
                            Text(user.name)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color.clear) // Permet d'afficher le fond dégradé derrière la liste
                    .onAppear {
                        viewModel.fetchUsers()  // Charger les utilisateurs dès que la vue apparaît
                    }

                    Button(action: {
                        let newUser = UserToSubmit(firstname: "enter", name: "Nouvel Utilisateur", email: "enter", address: "enter", role: UserRole.buyer)
                        viewModel.createUser(user: newUser)
                    }) {
                        Text("Ajouter un utilisateur")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
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
                    .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
            )
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

