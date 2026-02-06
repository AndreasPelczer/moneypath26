import SwiftUI
import Observation

@Observable
class FinanceViewModel {
    // Falls diese Variablen fehlen, findet DashboardView den Typ nicht!
    @ObservationIgnored @AppStorage("giroBalance") var giroBalance: Double = 0.0
    @ObservationIgnored @AppStorage("savingsBalance") var savingsBalance: Double = 0.0
    @ObservationIgnored @AppStorage("targetGoal") var targetGoal: Double = 4000.0
    @ObservationIgnored @AppStorage("targetDate") var targetDate: Date = Date().addingTimeInterval(3600*24*150)
    @ObservationIgnored @AppStorage("extraMoneyName") var extraMoneyName: String = "ExtraMoney"

    @ObservationIgnored @AppStorage("monthlyIncome") var monthlyIncome: Double = 2250.0
    @ObservationIgnored @AppStorage("fixedCosts") var fixedCosts: Double = 770.0
    @ObservationIgnored @AppStorage("foodBudget") var foodBudget: Double = 150.0
    @ObservationIgnored @AppStorage("careBudget") var careBudget: Double = 40.0
    @ObservationIgnored @AppStorage("clothingBudget") var clothingBudget: Double = 60.0
    
    var hobbyLimit: Double { didSet { UserDefaults.standard.set(hobbyLimit, forKey: "hobbyLimit") } }
    var extrasBudget: Double { didSet { UserDefaults.standard.set(extrasBudget, forKey: "extrasBudget") } }
    
    var selectedMonthIndex: Int = 0
    let monthNames = ["Jan", "Feb", "Mär", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]
    
    init() {
        self.hobbyLimit = UserDefaults.standard.double(forKey: "hobbyLimit") == 0 ? 200.0 : UserDefaults.standard.double(forKey: "hobbyLimit")
        self.extrasBudget = UserDefaults.standard.double(forKey: "extrasBudget") == 0 ? 50.0 : UserDefaults.standard.double(forKey: "extrasBudget")
    }

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
    
    var monthlyExtraSurplus: Double {
        let expenses = fixedCosts + foodBudget + careBudget + clothingBudget + hobbyLimit + extrasBudget
        let left = monthlyIncome - expenses - requiredMonthlySavings
        return max(0, left)
    }

    var accumulatedExtraMoney: Double {
        monthlyExtraSurplus * Double(selectedMonthIndex + 1)
    }

    var monthlySavings: Double {
        requiredMonthlySavings + monthlyExtraSurplus
    }

    var prognosisData: [Double] {
        var data: [Double] = []
        var runningTotal = currentTotal
        for _ in 0..<12 {
            data.append(runningTotal)
            runningTotal += requiredMonthlySavings
        }
        return data
    }
}
