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
                
                Picker("Monat", selection: $viewModel.selectedMonthIndex) {
                    ForEach(0..<viewModel.monthNames.count, id: \.self) {
                        Text(viewModel.monthNames[$0]).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                
                VStack(spacing: 20) {
                    Text("Deine Hebel").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                    BudgetSlider(title: "Hobby-Limit", value: $viewModel.hobbyLimit, range: 0...800, color: .orange, icon: "bicycle")
                    BudgetSlider(title: "Extras (Bier/Eis)", value: $viewModel.extrasBudget, range: 0...200, color: .red, icon: "mug.fill")
                }
                .padding().background(RoundedRectangle(cornerRadius: 25).fill(Color(.secondarySystemBackground)))
                
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
