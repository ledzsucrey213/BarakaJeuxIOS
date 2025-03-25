import SwiftUI

struct FinancialReportView: View {
    @StateObject private var viewModel: ReportViewModel
    let seller: User

    init(seller: User) {
        self.seller = seller
        _viewModel = StateObject(wrappedValue: ReportViewModel(sellerID: seller.id ?? ""))
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
                        Text("Rapports financiers de \(seller.name)")
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

// Composant de carte rapport financier
struct ReportCard: View {
    let report: Report
    let eventName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🗓 Date du rapport: \(formattedDate(report.reportDate))")
                .font(.headline)

            if let eventName = eventName {
                Text("🎮 Événement: \(eventName)")
                    .font(.subheadline)
            }

            Text("💰 Montant total gagné: \(String(format: "%.2f", report.totalEarned)) €")
                .font(.subheadline)
            Text("💸 Montant total dû: \(String(format: "%.2f", report.totalDue)) €")
                .font(.subheadline)

            NavigationLink(destination: SellerReportView(report: report, eventName: eventName)) {
                Text("Consulter")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

