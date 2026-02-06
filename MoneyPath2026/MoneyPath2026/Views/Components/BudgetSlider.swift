import SwiftUI

struct BudgetSlider: View {
    let title: String; @Binding var value: Double; let range: ClosedRange<Double>; let color: Color; let icon: String
    var body: some View {
        VStack(spacing: 8) {
            HStack { Label(title, systemImage: icon); Spacer(); Text("\(value, specifier: "%.0f") €").bold().foregroundStyle(color) }
            Slider(value: $value, in: range, step: 10).tint(color)
        }
    }
}
