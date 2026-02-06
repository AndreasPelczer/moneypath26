import SwiftUI

@main
struct MoneyPath2026App: App {
    @State private var viewModel = FinanceViewModel()
    @AppStorage("isSetupComplete") private var isSetupComplete: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isSetupComplete {
                    DashboardView(viewModel: viewModel)
                } else {
                    SetupView(viewModel: viewModel)
                }
            }
        }
    }
}
