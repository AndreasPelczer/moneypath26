import SwiftUI
import Charts

struct SavingsPowerChart: View {
    let viewModel: FinanceViewModel

    private var chartData: [(label: String, value: Double, color: Color)] {
        [
            ("Miete/Fixes", viewModel.fixedCosts, .gray),
            ("Lebensmittel", viewModel.foodBudget, .green),
            ("Pflege", viewModel.careBudget, .teal),
            ("Kleidung", viewModel.clothingBudget, .purple),
            ("Hobby", viewModel.hobbyLimit, .orange),
            ("Extras", viewModel.extrasBudget, .red),
            ("Sparen", viewModel.monthlySavingsTarget, .blue),
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Kosten-Struktur").font(.headline)

            Chart {
                ForEach(chartData, id: \.label) { item in
                    BarMark(
                        x: .value("Kategorie", "Monat"),
                        y: .value("€", item.value)
                    )
                    .foregroundStyle(item.color.gradient)
                }
            }
            .frame(height: 200)

            // Legende
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                ForEach(chartData, id: \.label) { item in
                    HStack(spacing: 6) {
                        Circle().fill(item.color).frame(width: 8, height: 8)
                        Text("\(item.label): \(item.value, specifier: "%.0f") €")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).fill(Color(.secondarySystemBackground)))
    }
}
