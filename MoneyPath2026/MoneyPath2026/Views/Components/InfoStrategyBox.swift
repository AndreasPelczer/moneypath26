import SwiftUI

struct InfoStrategyBox: View {
    let amount: Double; let extraName: String; let month: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Image(systemName: "sparkles").foregroundStyle(.blue); Text(extraName).font(.headline) }
            Text("Bis Ende **\(month)** hättest du insgesamt **\(amount, specifier: "%.2f") €** für **\(extraName)** übrig.")
                .font(.subheadline)
            Text("Das Sparziel ist bereits sicher abgezogen.").font(.caption2).foregroundStyle(.secondary)
        }.padding().frame(maxWidth: .infinity, alignment: .leading).background(RoundedRectangle(cornerRadius: 20).fill(Color.blue.opacity(0.1)))
    }
}
