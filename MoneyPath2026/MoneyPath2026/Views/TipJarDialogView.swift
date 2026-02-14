import SwiftUI

struct TipJarDialogView: View {
    var tipJarManager: TipJarManager
    var storeManager: StoreManager
    /// When true, skips Step 1 and starts directly at Step 2 (used from About/Settings)
    var skipToPayment: Bool = false

    @Environment(\.dismiss) private var dismiss
    @State private var step: Int = 1
    @State private var isPurchasing: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                switch step {
                case 1:
                    stepOneView
                        .transition(.opacity)
                case 2:
                    stepTwoView
                        .transition(.opacity)
                case 3:
                    stepThreeView
                        .transition(.opacity)
                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: 500)
            .frame(maxWidth: .infinity)
            .animation(.easeInOut(duration: 0.3), value: step)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if step < 3 {
                        Button("Schließen") {
                            if step == 1 || step == 2 {
                                tipJarManager.recordDismiss()
                            }
                            dismiss()
                        }
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    }
                }
            }
            .task {
                await storeManager.loadProducts()
                if skipToPayment {
                    step = 2
                }
            }
        }
    }

    // MARK: - Step 1: Der emotionale Moment

    private var stepOneView: some View {
        VStack(spacing: 24) {
            Spacer()

            switch tipJarManager.currentTrigger {
            case .usage(let count):
                usageText(count: count)
            case .goalReached:
                goalReachedText
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    withAnimation { step = 2 }
                } label: {
                    Label("Einen Kaffee zurückgeben", systemImage: "cup.and.saucer.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue.opacity(0.85))

                Button {
                    tipJarManager.recordDismiss()
                    dismiss()
                } label: {
                    Text("Nicht jetzt")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 24)
    }

    private func usageText(count: Int) -> some View {
        VStack(spacing: 16) {
            Text("Du hast moneypath **\(count) mal** geöffnet.")
                .font(.title2)
                .multilineTextAlignment(.center)

            Text("Das sind \(count) Momente, in denen du auf dein Geld geachtet hast.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("Deine Bank verdient daran. Ich nicht.")
                .font(.body)
                .multilineTextAlignment(.center)

            Text("Und das ist okay so. 🐟")
                .font(.body)
                .multilineTextAlignment(.center)
        }
    }

    private var goalReachedText: some View {
        VStack(spacing: 16) {
            Text("Ziel erreicht. 🎯")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text("Der Goldfisch hat schon vergessen, dass du Schulden hattest.\nDu nicht.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("Ich war nur Mathematik.\nDu warst Disziplin. 🐟")
                .font(.body)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Step 2: Der Ehrlichkeits-Moment

    private var stepTwoView: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text("Kurz, bevor du tippst:")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)

                Text("Diese App sammelt nichts. Verkauft nichts.\nManipuliert dich nicht. Hat kein Abo.\nHat keinen Investor.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text("Nur ein Koch, der Code schreibt.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }

            Spacer()

            if storeManager.isLoading {
                ProgressView()
                    .padding()
            } else if let error = storeManager.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                tipButtons
            }

            Button {
                if !skipToPayment {
                    tipJarManager.recordDismiss()
                }
                dismiss()
            } label: {
                Text("Doch nicht")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 30)
            .disabled(isPurchasing)
        }
        .padding(.horizontal, 24)
    }

    private var tipButtons: some View {
        VStack(spacing: 12) {
            tipButton(
                emoji: "☕",
                label: "Kaffee",
                productID: "tip_coffee",
                fallbackPrice: "1,99 €"
            )
            tipButton(
                emoji: "🍺",
                label: "Feierabendbier",
                productID: "tip_beer",
                fallbackPrice: "4,99 €"
            )
            tipButton(
                emoji: "🍾",
                label: "Champagner",
                productID: "tip_champagne",
                fallbackPrice: "9,99 €"
            )
        }
    }

    private func tipButton(emoji: String, label: String, productID: String, fallbackPrice: String) -> some View {
        Button {
            Task {
                await handlePurchase(productID: productID)
            }
        } label: {
            HStack {
                Text(emoji)
                    .font(.title3)
                Text(label)
                    .font(.headline)
                Spacer()
                Text(storeManager.displayPrice(for: productID, fallback: fallbackPrice))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
        .disabled(isPurchasing)
        .opacity(isPurchasing ? 0.6 : 1.0)
    }

    private func handlePurchase(productID: String) async {
        guard let product = storeManager.product(for: productID) else { return }
        isPurchasing = true
        let success = await storeManager.purchase(product)
        isPurchasing = false

        if success {
            tipJarManager.recordTipGiven()
            withAnimation { step = 3 }
        }
    }

    // MARK: - Step 3: Der Danke-Moment

    private var stepThreeView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                VStack(spacing: 12) {
                    Text("Das Internet hat kurz an\nFreundlichkeit gewonnen.")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    Text("Danke. Wirklich.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                DeadRabbitUniverseCard()
                    .padding(.top, 8)

                Button {
                    dismiss()
                } label: {
                    Text("Alles klar 🐟")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue.opacity(0.85))
                .padding(.top, 8)

                Spacer(minLength: 30)
            }
            .padding(.horizontal, 24)
        }
    }
}
