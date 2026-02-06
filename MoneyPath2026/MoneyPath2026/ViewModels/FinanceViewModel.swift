import SwiftUI
import Observation

@Observable
class FinanceViewModel {
    // MARK: - Setup-Werte (fix, werden im Setup gesetzt)

    var giroBalance: Double {
        get { UserDefaults.standard.double(forKey: "giroBalance") }
        set { UserDefaults.standard.set(newValue, forKey: "giroBalance") }
    }

    var savingsBalance: Double {
        get { UserDefaults.standard.double(forKey: "savingsBalance") }
        set { UserDefaults.standard.set(newValue, forKey: "savingsBalance") }
    }

    var targetGoal: Double {
        get {
            let v = UserDefaults.standard.double(forKey: "targetGoal")
            return v == 0 ? 4000.0 : v
        }
        set { UserDefaults.standard.set(newValue, forKey: "targetGoal") }
    }

    var targetDate: Date {
        get {
            let stored = UserDefaults.standard.object(forKey: "targetDate") as? Date
            return stored ?? Date().addingTimeInterval(3600 * 24 * 150)
        }
        set { UserDefaults.standard.set(newValue, forKey: "targetDate") }
    }

    var extraMoneyName: String {
        get {
            let v = UserDefaults.standard.string(forKey: "extraMoneyName")
            return (v == nil || v!.isEmpty) ? "ExtraMoney" : v!
        }
        set { UserDefaults.standard.set(newValue, forKey: "extraMoneyName") }
    }

    var monthlyIncome: Double {
        get {
            let v = UserDefaults.standard.double(forKey: "monthlyIncome")
            return v == 0 ? 2250.0 : v
        }
        set { UserDefaults.standard.set(newValue, forKey: "monthlyIncome") }
    }

    var fixedCosts: Double {
        get {
            let v = UserDefaults.standard.double(forKey: "fixedCosts")
            return v == 0 ? 770.0 : v
        }
        set { UserDefaults.standard.set(newValue, forKey: "fixedCosts") }
    }

    // MARK: - Hebel (Slider im Dashboard)

    var foodBudget: Double {
        didSet { UserDefaults.standard.set(foodBudget, forKey: "foodBudget"); clampSavings() }
    }

    var careBudget: Double {
        didSet { UserDefaults.standard.set(careBudget, forKey: "careBudget"); clampSavings() }
    }

    var clothingBudget: Double {
        didSet { UserDefaults.standard.set(clothingBudget, forKey: "clothingBudget"); clampSavings() }
    }

    var hobbyLimit: Double {
        didSet { UserDefaults.standard.set(hobbyLimit, forKey: "hobbyLimit"); clampSavings() }
    }

    var extrasBudget: Double {
        didSet { UserDefaults.standard.set(extrasBudget, forKey: "extrasBudget"); clampSavings() }
    }

    var monthlySavingsTarget: Double {
        didSet { UserDefaults.standard.set(monthlySavingsTarget, forKey: "monthlySavingsTarget") }
    }

    private func clampSavings() {
        if monthlySavingsTarget > maxSavings {
            monthlySavingsTarget = maxSavings
        }
    }

    // MARK: - UI State

    var selectedMonthIndex: Int = 0

    // Dynamische Monatsnamen ab aktuellem Monat
    var monthNames: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        let allMonths = formatter.shortMonthSymbols!
        let currentMonth = Calendar.current.component(.month, from: Date()) - 1
        return (0..<12).map { allMonths[(currentMonth + $0) % 12] }
    }

    // Ausgewählter Monat als Label (z.B. "Feb 2026")
    var selectedMonthLabel: String {
        let cal = Calendar.current
        guard let date = cal.date(byAdding: .month, value: selectedMonthIndex, to: Date()) else {
            return monthNames[selectedMonthIndex]
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

    // MARK: - Init

    init() {
        self.foodBudget = Self.loadOrDefault("foodBudget", fallback: 150.0)
        self.careBudget = Self.loadOrDefault("careBudget", fallback: 40.0)
        self.clothingBudget = Self.loadOrDefault("clothingBudget", fallback: 60.0)
        self.hobbyLimit = Self.loadOrDefault("hobbyLimit", fallback: 200.0)
        self.extrasBudget = Self.loadOrDefault("extrasBudget", fallback: 50.0)
        self.monthlySavingsTarget = Self.loadOrDefault("monthlySavingsTarget", fallback: 300.0)
    }

    private static func loadOrDefault(_ key: String, fallback: Double) -> Double {
        UserDefaults.standard.object(forKey: key) != nil
            ? UserDefaults.standard.double(forKey: key)
            : fallback
    }

    // MARK: - Berechnungen

    var currentTotal: Double { giroBalance + savingsBalance }

    var monthsRemaining: Double {
        let diff = Calendar.current.dateComponents([.month, .day], from: Date(), to: targetDate)
        let m = Double(diff.month ?? 0)
        let d = Double(diff.day ?? 0) / 30.0
        return max(0.5, m + d)
    }

    // Info: was man bräuchte um das Ziel zu schaffen
    var requiredMonthlySavings: Double {
        let gap = targetGoal - currentTotal
        return gap > 0 ? gap / monthsRemaining : 0
    }

    var lifestyleExpenses: Double {
        foodBudget + careBudget + clothingBudget + hobbyLimit + extrasBudget
    }

    var totalExpenses: Double {
        fixedCosts + lifestyleExpenses
    }

    // Wieviel ist maximal zum Sparen verfügbar
    var maxSavings: Double {
        max(0, monthlyIncome - totalExpenses)
    }

    // Was nach allen Ausgaben + Sparrate übrig bleibt = Extra Money
    var monthlyExtraSurplus: Double {
        max(0, monthlyIncome - totalExpenses - monthlySavingsTarget)
    }

    var accumulatedExtraMoney: Double {
        monthlyExtraSurplus * Double(selectedMonthIndex)
    }

    // Wird das Sparziel mit der aktuellen Sparrate erreicht?
    var goalReachable: Bool {
        monthlySavingsTarget >= requiredMonthlySavings
    }

    var prognosisData: [Double] {
        var data: [Double] = []
        var runningTotal = currentTotal
        data.append(runningTotal) // Monat 0 = jetzt, nur Kontostand
        for _ in 1..<12 {
            runningTotal += monthlySavingsTarget
            data.append(runningTotal)
        }
        return data
    }
}
