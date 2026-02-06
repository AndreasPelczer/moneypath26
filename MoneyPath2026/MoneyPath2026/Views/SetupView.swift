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
                    LabeledContent("Lebensmittel") {
                        TextField("0", value: $viewModel.foodBudget, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Pflege & Hygiene") {
                        TextField("0", value: $viewModel.careBudget, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Kleidung") {
                        TextField("0", value: $viewModel.clothingBudget, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Flexible Ausgaben") {
                    LabeledContent("Hobby-Budget") {
                        TextField("0", value: $viewModel.hobbyLimit, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Extras (Bier/Eis)") {
                        TextField("0", value: $viewModel.extrasBudget, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
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
        if viewModel.totalExpenses >= viewModel.monthlyIncome {
            return "Deine Ausgaben übersteigen dein Einkommen."
        }
        return nil
    }
}
