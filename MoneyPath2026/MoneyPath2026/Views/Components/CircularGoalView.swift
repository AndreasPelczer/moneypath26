import SwiftUI

struct CircularGoalView: View {
    let current: Double
    let target: Double
    let month: String

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var ringHeight: CGFloat {
        horizontalSizeClass == .regular ? 260 : 180
    }

    var body: some View {
        VStack {
            Text("Voraussichtlicher Stand \(month)").font(.caption)
            ZStack {
                Circle().stroke(Color.blue.opacity(0.1), lineWidth: 20)
                Circle().trim(from: 0, to: CGFloat(min(current/target, 1.0)))
                    .stroke(current >= target ? Color.green : Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack {
                    Text("\(current, specifier: "%.0f") €").font(.title.bold())
                    Text("Ziel: \(target, specifier: "%.0f") €").font(.caption2)
                }
            }.frame(height: ringHeight)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 30).fill(Color(.secondarySystemBackground)))
    }
}
