import SwiftUI

struct SupportView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                ZStack {
                    Circle().fill(Color.blue.gradient).frame(width: 100, height: 100)
                    Image(systemName: "heart.fill").font(.system(size: 50)).foregroundStyle(.white)
                }.padding(.top, 40)
                List {
                    Section("Support via PayPal") {
                        Link(destination: URL(string: "https://www.paypal.me/pelczer")!) {
                            HStack { Image(systemName: "p.square.fill").foregroundStyle(.blue); Text("Trinkgeld senden").bold(); Spacer(); Image(systemName: "arrow.up.right") }
                        }
                    }
                }.listStyle(.insetGrouped)
            }.navigationTitle("Kaffee-Kasse").toolbar { Button("Fertig") { dismiss() } }
        }
    }
}
