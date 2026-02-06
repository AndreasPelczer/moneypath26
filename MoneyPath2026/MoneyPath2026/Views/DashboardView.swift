import SwiftUI

struct DashboardView: View {
    @Bindable var viewModel: FinanceViewModel
    @State private var showSettings = false
    @State private var showSupport = false

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
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

                    // Monatspunkte als visuelle Orientierung
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

                VStack(spacing: 20) {
                    Text("Deine Hebel").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    BudgetSlider(title: "Hobby-Limit", value: $viewModel.hobbyLimit, range: 0...800, color: .orange, icon: "bicycle")
                    BudgetSlider(title: "Extras (Bier/Eis)", value: $viewModel.extrasBudget, range: 0...200, color: .red, icon: "mug.fill")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 25).fill(Color(.secondarySystemBackground)))

                SavingsPowerChart(viewModel: viewModel)

                InfoStrategyBox(
                    amount: viewModel.accumulatedExtraMoney,
                    extraName: viewModel.extraMoneyName,
                    month: viewModel.monthNames[viewModel.selectedMonthIndex]
                )
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
                Button { showSettings = true } label: { Image(systemName: "gearshape.fill") }
            }
        }
        .sheet(isPresented: $showSettings) { SetupView(viewModel: viewModel) }
        .sheet(isPresented: $showSupport) { SupportView() }
    }
}
