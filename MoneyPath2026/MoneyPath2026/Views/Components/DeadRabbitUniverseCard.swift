import SwiftUI

struct DeadRabbitUniverseCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Text("🐰")
                    .font(.footnote)
                Text("Dead Rabbit Productions")
                    .font(.footnote.bold())
                    .foregroundStyle(.secondary)
            }

            Divider()

            Text("Ein Mensch. Keine Firma. Ehrliche Apps.")
                .font(.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 6) {
                // SOLARA
                // TODO: Replace with actual App Store URL for SOLARA
                Link(destination: URL(string: "https://apps.apple.com/app/solara/id0000000000")!) {
                    HStack(spacing: 6) {
                        Text("🐟")
                            .font(.caption)
                        Text("SOLARA")
                            .font(.caption.bold())
                        Text("– für wenn das Leben zu ernst wird")
                            .font(.caption)
                    }
                    .foregroundStyle(.primary)
                }

                // Der Küchencode
                // TODO: Replace with actual Amazon URL for "Der Küchencode"
                Link(destination: URL(string: "https://www.amazon.de/dp/0000000000")!) {
                    HStack(spacing: 6) {
                        Text("📖")
                            .font(.caption)
                        Text("Der Küchencode")
                            .font(.caption.bold())
                        Text("– 36 Jahre Küche, ungefiltert")
                            .font(.caption)
                    }
                    .foregroundStyle(.primary)
                }

                // iMOPS (no link, still in TestFlight)
                HStack(spacing: 6) {
                    Text("🔧")
                        .font(.caption)
                    Text("iMOPS")
                        .font(.caption.bold())
                    Text("– damit Arbeit nicht krank macht")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // pelczer.de
                Link(destination: URL(string: "https://pelczer.de")!) {
                    HStack(spacing: 4) {
                        Text("→")
                            .font(.caption)
                        Text("pelczer.de")
                            .font(.caption.bold())
                    }
                    .foregroundStyle(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.tertiarySystemBackground))
        )
    }
}
