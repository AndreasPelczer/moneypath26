import SwiftUI

struct DeadRabbitAboutView: View {
    var storeManager: StoreManager
    var tipJarManager: TipJarManager

    @State private var showTipDialog: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // About text
                VStack(alignment: .leading, spacing: 12) {
                    Text("Über diese App")
                        .font(.title2.bold())

                    Text("moneypath wird gebaut von einem Menschen, nicht einer Firma.")
                        .font(.body)

                    Text("Kein Tracking. Kein Abo. Keine Werbung.\nWenn sie nützlich war, darfst du mir einen Kaffee schicken.\nWenn nicht, ist auch gut.")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Text("— Andreas / Dead Rabbit Productions")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 4)

                // Universe Card
                DeadRabbitUniverseCard()

                // Permanent tip button
                Button {
                    showTipDialog = true
                } label: {
                    Label("Kaffee spendieren", systemImage: "cup.and.saucer.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue.opacity(0.85))
            }
            .padding()
        }
        .navigationTitle("Über moneypath")
        .sheet(isPresented: $showTipDialog) {
            TipJarDialogView(
                tipJarManager: tipJarManager,
                storeManager: storeManager,
                skipToPayment: true
            )
        }
    }
}
