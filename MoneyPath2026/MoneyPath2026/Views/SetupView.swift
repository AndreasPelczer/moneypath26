import SwiftUI

struct SetupView: View {
    @Bindable var viewModel: FinanceViewModel
    @Environment(\.dismiss) var dismiss
    @AppStorage("isSetupComplete") private var isSetupComplete: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Dein Sparziel") {
                    TextField("Zielbetrag (€)", value: $viewModel.targetGoal, format: .number)
                        .keyboardType(.decimalPad)
                    DatePicker("Zieldatum", selection: $viewModel.targetDate, in: Date()..., displayedComponents: .date)
                    TextField("Name des Extras (z.B. Jever Reise)", text: $viewModel.extraMoneyName)
                }

                Section("Einnahmen & Konten") {
                    LabeledContent("Girokonto (€)") {
                        TextField("0", value: $viewModel.giroBalance, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Sparbuch (€)") {
                        TextField("0", value: $viewModel.savingsBalance, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Lohn Netto (€)") {
                        TextField("0", value: $viewModel.monthlyIncome, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Fixkosten") {
                    LabeledContent("Miete & Nebenkosten") {
                        TextField("0", value: $viewModel.fixedCosts, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section {
                    Text("Alle anderen Budgets kannst du im Dashboard mit Slidern anpassen.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let warning = validationWarning {
                    Section {
                        Label(warning, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .font(.subheadline)
                    }
                }

                Button("Setup abschließen") {
                    isSetupComplete = true
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .disabled(validationWarning != nil)
            }
            .navigationTitle("Konfiguration")
        }
    }

    private var validationWarning: String? {
        if viewModel.monthlyIncome <= 0 {
            return "Bitte trag dein monatliches Einkommen ein."
        }
        if viewModel.targetGoal <= 0 {
            return "Dein Sparziel muss größer als 0 sein."
        }
        if viewModel.fixedCosts >= viewModel.monthlyIncome {
            return "Deine Fixkosten übersteigen dein Einkommen."
        }
        return nil
    }
}
