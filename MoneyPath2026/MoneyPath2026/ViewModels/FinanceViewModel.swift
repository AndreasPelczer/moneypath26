import SwiftUI
import Observation

@Observable
class FinanceViewModel {
    // MARK: - Persisted Properties (reactive via manual notify)

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

    var foodBudget: Double {
        get {
            let v = UserDefaults.standard.double(forKey: "foodBudget")
            return v == 0 ? 150.0 : v
        }
        set { UserDefaults.standard.set(newValue, forKey: "foodBudget") }
    }

    var careBudget: Double {
        get {
            let v = UserDefaults.standard.double(forKey: "careBudget")
            return v == 0 ? 40.0 : v
        }
        set { UserDefaults.standard.set(newValue, forKey: "careBudget") }
    }

    var clothingBudget: Double {
        get {
            let v = UserDefaults.standard.double(forKey: "clothingBudget")
            return v == 0 ? 60.0 : v
        }
        set { UserDefaults.standard.set(newValue, forKey: "clothingBudget") }
    }

    var hobbyLimit: Double {
        didSet { UserDefaults.standard.set(hobbyLimit, forKey: "hobbyLimit") }
    }

    var extrasBudget: Double {
        didSet { UserDefaults.standard.set(extrasBudget, forKey: "extrasBudget") }
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
        let storedHobby = UserDefaults.standard.object(forKey: "hobbyLimit")
        self.hobbyLimit = storedHobby != nil ? UserDefaults.standard.double(forKey: "hobbyLimit") : 200.0

        let storedExtras = UserDefaults.standard.object(forKey: "extrasBudget")
        self.extrasBudget = storedExtras != nil ? UserDefaults.standard.double(forKey: "extrasBudget") : 50.0
    }

    // MARK: - Berechnungen

    var currentTotal: Double { giroBalance + savingsBalance }

    var monthsRemaining: Double {
        let diff = Calendar.current.dateComponents([.month, .day], from: Date(), to: targetDate)
        let m = Double(diff.month ?? 0)
        let d = Double(diff.day ?? 0) / 30.0
        return max(0.5, m + d)
    }

    var requiredMonthlySavings: Double {
        let gap = targetGoal - currentTotal
        return gap > 0 ? gap / monthsRemaining : 0
    }

    var totalExpenses: Double {
        fixedCosts + foodBudget + careBudget + clothingBudget + hobbyLimit + extrasBudget
    }

    var monthlyExtraSurplus: Double {
        let left = monthlyIncome - totalExpenses - requiredMonthlySavings
        return max(0, left)
    }

    var accumulatedExtraMoney: Double {
        monthlyExtraSurplus * Double(selectedMonthIndex)
    }

    var monthlySavings: Double {
        requiredMonthlySavings + monthlyExtraSurplus
    }

    var prognosisData: [Double] {
        var data: [Double] = []
        var runningTotal = currentTotal
        data.append(runningTotal) // Monat 0 = jetzt, nur Kontostand
        for _ in 1..<12 {
            runningTotal += monthlySavings
            data.append(runningTotal)
        }
        return data
    }
}
