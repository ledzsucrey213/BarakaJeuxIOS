import SwiftUI

struct ReportMagasinView: View {
    @StateObject private var viewModel: ReportViewModel

    init() {
        _viewModel = StateObject(wrappedValue: ReportViewModel(sellerID: "675c75c5cd3b594a7528034f"))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Fond dégradé
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Rapports financiers de BarakaJeux")
                            .font(.title)
                            .bold()
                            .padding(.top, 40)

                        ForEach(viewModel.reports, id: \.id) { report in
                            ReportCard(report: report, eventName: viewModel.eventsNames[report.eventId])
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .onAppear {
                viewModel.fetchReports()
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

