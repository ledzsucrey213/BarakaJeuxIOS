import SwiftUI

struct NewSellerView: View {
    @StateObject private var viewModel = NewSellerViewModel()
    @Environment(\.presentationMode) var presentationMode
    var onUpdate: (() -> Void)?
    
    init(onUpdate: (() -> Void)? = nil) {
        self.onUpdate = onUpdate
        _viewModel = StateObject(wrappedValue: NewSellerViewModel())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            
            Text("Créer un Vendeur")
                .font(.largeTitle)
                .bold()
                
            

            TextField("Prénom", text: $viewModel.firstname)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nom", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Adresse")
                    .font(.headline) // Utilise une taille de police plus grande pour l'intitulé
                    .foregroundColor(.gray)

            TextEditor(text: $viewModel.address)
                .frame(height: 150) // Ajuste la hauteur pour plus de confort
                .border(Color.gray, width: 1) // Ajoute une bordure pour plus de visibilité
                .cornerRadius(8)
                .padding(.bottom, 10)

            Button(action: {
                viewModel.createSeller {
                    onUpdate?()
                    presentationMode.wrappedValue.dismiss() // Ferme la vue après la création
                }
            }) {
                Text("Créer le vendeur")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            .navigationBarItems(
                                    leading:
                                        HStack {
                                            DropdownMenu() // Menu à gauche
                                            Spacer()

                                        }
                                        .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
                                )

            Spacer()
        }
        .padding()
        
        
    }
}

