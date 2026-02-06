//
//  MoneyPath2026App.swift
//  MoneyPath2026
//
//  Created by Andreas Pelczer on 11.01.26.
//

import SwiftUI
import SwiftData

@main
struct MoneyPath2026App: App {
    // Hier erstellen wir das ViewModel einmal zentral für die ganze App
    @State private var viewModel = FinanceViewModel()
    @AppStorage("isSetupComplete") private var isSetupComplete: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isSetupComplete {
                    // Startet direkt im Dashboard, wenn Daten da sind
                    DashboardView(viewModel: viewModel)
                } else {
                    // Startet im Setup, wenn die App neu ist
                    SetupView(viewModel: viewModel)
                }
            }
        }
    }
}
