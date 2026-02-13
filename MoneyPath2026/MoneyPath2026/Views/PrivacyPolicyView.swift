import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Datenschutzerkl\u{00E4}rung")
                            .font(.title.bold())

                        Text("Zuletzt aktualisiert: Februar 2026")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    section(
                        title: "1. Datenerhebung",
                        content: "MoneyPath2026 speichert alle deine Daten ausschlie\u{00DF}lich lokal auf deinem Ger\u{00E4}t. Es werden keine pers\u{00F6}nlichen Daten an Server, Cloud-Dienste oder Dritte \u{00FC}bertragen."
                    )

                    section(
                        title: "2. Gespeicherte Daten",
                        content: "Die App speichert folgende von dir eingegebene Daten lokal auf deinem Ger\u{00E4}t:\n\u{2022} Sparziel und Zieldatum\n\u{2022} Kontost\u{00E4}nde (Giro, Sparbuch)\n\u{2022} Monatliches Einkommen\n\u{2022} Fixkosten und Budgets\n\nDiese Daten verlassen niemals dein Ger\u{00E4}t."
                    )

                    section(
                        title: "3. Keine Tracking-Dienste",
                        content: "MoneyPath2026 verwendet keine Analytics, kein Tracking, keine Werbung und keine Drittanbieter-SDKs. Deine Finanzdaten bleiben privat."
                    )

                    section(
                        title: "4. Datenl\u{00F6}schung",
                        content: "Du kannst alle gespeicherten Daten jederzeit l\u{00F6}schen, indem du die App von deinem Ger\u{00E4}t deinstallierst."
                    )

                    section(
                        title: "5. Kontakt",
                        content: "Bei Fragen zum Datenschutz erreichst du den Entwickler \u{00FC}ber die Support-Funktion in der App."
                    )
                }
                .padding()
            }
            .navigationTitle("Datenschutz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Fertig") { dismiss() }
            }
        }
    }

    private func section(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            Text(content).font(.subheadline).foregroundStyle(.secondary)
        }
    }
}
