//
//  EventView.swift
//  BarakaJeux
//
//  Created by etud on 16/03/2025.
//

import SwiftUI


struct EventView: View {
    @StateObject private var viewModel: EventViewModel
    @Environment(\.presentationMode) var presentationMode
    var onUpdate: (() -> Void)?

    
    init(event: Event, onUpdate: (() -> Void)? = nil) {
        self.onUpdate = onUpdate
        _viewModel = StateObject(wrappedValue: EventViewModel(event: event))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.event.name)
                .font(.largeTitle)
                .bold()
            
            TextField("Nom de l'évènement", text: $viewModel.event.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            DatePicker("Date de début", selection: $viewModel.event.start, displayedComponents: .date)
            DatePicker("Date de fin", selection: $viewModel.event.end, displayedComponents: .date)
            
            HStack {
                Text("Frais de dépôt")
                Spacer()
                TextField("Frais", value: $viewModel.event.depositFee, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .frame(width: 80)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("Commission à la vente")
                Spacer()
                TextField("Commission", value: $viewModel.event.commission, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .frame(width: 80)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button(action: {
                viewModel.updateEvent()
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

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event : Event(
            id: "1",
            name: "Tournoi de jeux de société",
            start: Date(timeIntervalSince1970: 1718014800), // Exemple : 10 juin 2024
            end: Date(timeIntervalSince1970: 1718101200),   // 10 juin 2024 (plus tard dans la journée)
            isActive: true,
            commission: 5.0,
            depositFee: 3.0
        ))
    }
}
