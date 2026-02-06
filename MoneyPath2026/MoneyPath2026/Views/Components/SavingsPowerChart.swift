import SwiftUI
import Charts

struct SavingsPowerChart: View {
    let viewModel: FinanceViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Kosten-Struktur").font(.headline)
            Chart {
                BarMark(x: .value("K", "Plan"), y: .value("€", viewModel.fixedCosts)).foregroundStyle(.gray.opacity(0.5))
                BarMark(x: .value("K", "Plan"), y: .value("€", viewModel.foodBudget)).foregroundStyle(.green.opacity(0.6))
                BarMark(x: .value("K", "Plan"), y: .value("€", viewModel.hobbyLimit)).foregroundStyle(.orange)
                BarMark(x: .value("K", "Plan"), y: .value("€", viewModel.extrasBudget)).foregroundStyle(.red)
                BarMark(x: .value("K", "Plan"), y: .value("€", viewModel.monthlySavings)).foregroundStyle(.blue.gradient)
            }.frame(height: 200)
        }.padding().background(RoundedRectangle(cornerRadius: 25).fill(Color(.secondarySystemBackground)))
    }
}
