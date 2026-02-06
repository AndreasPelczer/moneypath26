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
                    DatePicker("Bis wann?", selection: $viewModel.targetDate, displayedComponents: .date)
                    TextField("Name des Extras (z.B. Jever Reise)", text: $viewModel.extraMoneyName)
                }
                
                Section("Einnahmen & Finanzen") {
                    LabeledContent("Girokonto") { TextField("0", value: $viewModel.giroBalance, format: .number).keyboardType(.decimalPad) }
                    LabeledContent("Sparbuch") { TextField("0", value: $viewModel.savingsBalance, format: .number).keyboardType(.decimalPad) }
                    LabeledContent("Lohn (Netto)") { TextField("0", value: $viewModel.monthlyIncome, format: .number).keyboardType(.decimalPad) }
                }

                Section("Fixkosten & Lifestyle") {
                    LabeledContent("Miete/Fixes") { TextField("0", value: $viewModel.fixedCosts, format: .number).keyboardType(.decimalPad) }
                    LabeledContent("Hobby-Budget") { TextField("0", value: $viewModel.hobbyLimit, format: .number).keyboardType(.decimalPad) }
                    LabeledContent("Bier/Extras") { TextField("0", value: $viewModel.extrasBudget, format: .number).keyboardType(.decimalPad) }
                }

                Button("Setup abschließen") {
                    isSetupComplete = true
                    dismiss()
                }
                .frame(maxWidth: .infinity).buttonStyle(.borderedProminent)
            }
            .navigationTitle("Konfiguration")
        }
    }
}
