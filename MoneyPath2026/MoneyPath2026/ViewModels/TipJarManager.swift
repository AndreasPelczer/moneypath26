import SwiftUI
import Observation

enum TipTrigger: Equatable {
    case usage(count: Int)
    case goalReached
}

@Observable
class TipJarManager {
    // MARK: - Persisted State

    var appOpenCount: Int {
        get { UserDefaults.standard.integer(forKey: "tipJar_appOpenCount") }
        set { UserDefaults.standard.set(newValue, forKey: "tipJar_appOpenCount") }
    }

    var goalsReachedCount: Int {
        get { UserDefaults.standard.integer(forKey: "tipJar_goalsReachedCount") }
        set { UserDefaults.standard.set(newValue, forKey: "tipJar_goalsReachedCount") }
    }

    var hasTippedBefore: Bool {
        get { UserDefaults.standard.bool(forKey: "tipJar_hasTippedBefore") }
        set { UserDefaults.standard.set(newValue, forKey: "tipJar_hasTippedBefore") }
    }

    var lastTipPromptDate: Date? {
        get { UserDefaults.standard.object(forKey: "tipJar_lastTipPromptDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "tipJar_lastTipPromptDate") }
    }

    var tipPromptDismissCount: Int {
        get { UserDefaults.standard.integer(forKey: "tipJar_tipPromptDismissCount") }
        set { UserDefaults.standard.set(newValue, forKey: "tipJar_tipPromptDismissCount") }
    }

    /// The open count at which the last usage prompt was shown
    private var lastUsagePromptOpenCount: Int {
        get { UserDefaults.standard.integer(forKey: "tipJar_lastUsagePromptOpenCount") }
        set { UserDefaults.standard.set(newValue, forKey: "tipJar_lastUsagePromptOpenCount") }
    }

    // MARK: - Published State

    var shouldShowTipDialog: Bool = false
    var currentTrigger: TipTrigger = .usage(count: 0)

    // MARK: - Methods

    func recordAppOpen() {
        appOpenCount += 1
        checkUsageTrigger()
    }

    func recordGoalReached() {
        goalsReachedCount += 1
        checkGoalTrigger()
    }

    func recordTipGiven() {
        hasTippedBefore = true
        shouldShowTipDialog = false
    }

    func recordDismiss() {
        tipPromptDismissCount += 1
        lastTipPromptDate = Date()
        lastUsagePromptOpenCount = appOpenCount
        shouldShowTipDialog = false
    }

    // MARK: - Trigger Logic

    private func checkUsageTrigger() {
        guard !hasTippedBefore else { return }
        guard tipPromptDismissCount < 3 else { return }

        let threshold: Int
        if lastUsagePromptOpenCount == 0 {
            // First prompt at 25 opens
            threshold = 25
        } else {
            // After dismiss: next prompt after 50 more opens
            threshold = lastUsagePromptOpenCount + 50
        }

        guard appOpenCount >= threshold else { return }

        currentTrigger = .usage(count: appOpenCount)
        shouldShowTipDialog = true
    }

    private func checkGoalTrigger() {
        guard !hasTippedBefore else { return }
        guard tipPromptDismissCount < 3 else { return }

        // Cooldown: at least 14 days since last prompt
        if let lastPrompt = lastTipPromptDate {
            let daysSinceLastPrompt = Calendar.current.dateComponents(
                [.day], from: lastPrompt, to: Date()
            ).day ?? 0
            guard daysSinceLastPrompt >= 14 else { return }
        }

        currentTrigger = .goalReached
        shouldShowTipDialog = true
    }
}
