//
//  MonthlyPrognosis.swift
//  MoneyPath2026
//
//  Created by Andreas Pelczer on 11.01.26.
//


import Foundation

struct MonthlyPrognosis: Identifiable {
    let id = UUID()
    let index: Int
    let monthName: String
    let predictedBalance: Double
}

// Später kannst du hier SwiftData @Model Klassen hinzufügen