//
//  userListView.swift
//  BarakaJeux
//
//  Created by etud on 18/03/2025.
//

import SwiftUI


struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Utilisateurs")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                List(viewModel.users) { user in
                    NavigationLink(destination: UserView(user: user, onUpdate: {
                        viewModel.fetchUsers() } )) {
                        Text(user.name)
                    }
                }
                .listStyle(.insetGrouped)
                
                .onAppear {
                    viewModel.fetchUsers()  // Charger les événements dès que la vue apparaît
                }


                Button(action: {
                    let newUser = User(name: "Nouvel Utilisateur")
                    viewModel.createUser(user: newUser)
                }) {
                    Text("Ajouter un utilisateur")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
                
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
}


struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

