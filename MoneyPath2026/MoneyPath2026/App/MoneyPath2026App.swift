import SwiftUI

@main
struct MoneyPath2026App: App {
    @State private var viewModel = FinanceViewModel()
    @State private var tipJarManager = TipJarManager()
    @State private var storeManager = StoreManager()
    @AppStorage("isSetupComplete") private var isSetupComplete: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isSetupComplete {
                    DashboardView(
                        viewModel: viewModel,
                        tipJarManager: tipJarManager,
                        storeManager: storeManager
                    )
                } else {
                    SetupView(viewModel: viewModel)
                }
            }
        }
    }
}
