import SwiftUI

struct DashboardView: View {
    @Bindable var viewModel: FinanceViewModel
    @State private var showSettings = false
    @State private var showSupport = false
    @State private var showPrivacy = false

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Sparziel-Ring
                CircularGoalView(
                    current: viewModel.prognosisData[viewModel.selectedMonthIndex],
                    target: viewModel.targetGoal,
                    month: viewModel.monthNames[viewModel.selectedMonthIndex]
                )

                // Monats-Slider
                VStack(spacing: 8) {
                    Text(viewModel.selectedMonthLabel)
                        .font(.title3.bold())
                        .contentTransition(.numericText())
                        .animation(.default, value: viewModel.selectedMonthIndex)

                    HStack {
                        Text(viewModel.monthNames.first ?? "")
                            .font(.caption2).foregroundStyle(.secondary)
                        Slider(
                            value: Binding(
                                get: { Double(viewModel.selectedMonthIndex) },
                                set: { viewModel.selectedMonthIndex = Int($0.rounded()) }
                            ),
                            in: 0...11,
                            step: 1
                        )
                        .tint(.blue)
                        Text(viewModel.monthNames.last ?? "")
                            .font(.caption2).foregroundStyle(.secondary)
                    }

                    HStack(spacing: 0) {
                        ForEach(0..<12, id: \.self) { i in
                            Circle()
                                .fill(i == viewModel.selectedMonthIndex ? Color.blue : Color.blue.opacity(0.2))
                                .frame(width: 6, height: 6)
                            if i < 11 { Spacer() }
                        }
                    }
                    .padding(.horizontal, 6)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(.secondarySystemBackground)))

                // Extra Money - das Herzstück
                InfoStrategyBox(
                    amount: viewModel.accumulatedExtraMoney,
                    extraName: viewModel.extraMoneyName,
                    month: viewModel.monthNames[viewModel.selectedMonthIndex]
                )

                // Spar-Hebel
                VStack(spacing: 20) {
                    HStack {
                        Text("Sparrate").font(.headline)
                        Spacer()
                        if viewModel.goalReachable {
                            Label("Ziel erreichbar", systemImage: "checkmark.circle.fill")
                                .font(.caption).foregroundStyle(.green)
                        } else {
                            Label("Brauchst \(viewModel.requiredMonthlySavings, specifier: "%.0f") €/M", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption).foregroundStyle(.orange)
                        }
                    }
                    BudgetSlider(
                        title: "Monatlich sparen",
                        value: $viewModel.monthlySavingsTarget,
                        range: 0...max(50, viewModel.maxSavings),
                        color: .blue,
                        icon: "banknote.fill"
                    )
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(.secondarySystemBackground)))

                // Lifestyle-Hebel
                VStack(spacing: 20) {
                    Text("Deine Hebel").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    BudgetSlider(title: "Lebensmittel", value: $viewModel.foodBudget, range: 50...500, color: .green, icon: "cart.fill")
                    BudgetSlider(title: "Pflege & Hygiene", value: $viewModel.careBudget, range: 0...200, color: .teal, icon: "drop.fill")
                    BudgetSlider(title: "Kleidung", value: $viewModel.clothingBudget, range: 0...300, color: .purple, icon: "tshirt.fill")
                    BudgetSlider(title: "Hobby", value: $viewModel.hobbyLimit, range: 0...800, color: .orange, icon: "bicycle")
                    BudgetSlider(title: "Extras (Bier/Eis)", value: $viewModel.extrasBudget, range: 0...200, color: .red, icon: "mug.fill")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(.secondarySystemBackground)))

                // Kosten-Übersicht
                SavingsPowerChart(viewModel: viewModel)
            }
            .padding()
        }
        .navigationTitle("Finanz-Coach")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { showSupport = true } label: {
                    Image(systemName: "heart.circle.fill").foregroundStyle(.red)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button { showPrivacy = true } label: {
                        Image(systemName: "lock.shield.fill").foregroundStyle(.gray)
                    }
                    Button { showSettings = true } label: { Image(systemName: "gearshape.fill") }
                }
            }
        }
        .sheet(isPresented: $showSettings) { SetupView(viewModel: viewModel) }
        .sheet(isPresented: $showSupport) { SupportView() }
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView() }
    }
}
