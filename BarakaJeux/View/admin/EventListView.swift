//
//  EventListView.swift
//  BarakaJeux
//
//  Created by etud on 18/03/2025.
//

import SwiftUI


struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Evènements")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                List(viewModel.events) { event in
                    NavigationLink(destination: EventView(event: event, onUpdate: {
                        viewModel.fetchEvents() } )) {
                        Text(event.name)
                    }
                }
                .onAppear {
                    viewModel.fetchEvents()  // Charger les événements dès que la vue apparaît
                }

                .listStyle(.insetGrouped)

                Button(action: {
                    let newEvent = Event(name: "Nouvel Evènement")
                    viewModel.createEvent(event: newEvent)
                }) {
                    Text("Ajouter un événement")
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
                                    }
                                    .frame(maxWidth: .infinity) // Permet de mieux positionner les éléments
                            )
            }
        }
    }
}


struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
