import Foundation

class FocusStateManager {
    static let shared = FocusStateManager()

    private let suiteName = "group.dev.nikiv.baseSafari"
    private let focusKey = "focusEnabled"

    private init() {}

    func isFocusEnabled() -> Bool {
        let defaults = UserDefaults(suiteName: suiteName)
        return defaults?.bool(forKey: focusKey) ?? false
    }

    func toggleFocusState() -> Bool {
        let newState = !isFocusEnabled()
        let defaults = UserDefaults(suiteName: suiteName)
        defaults?.set(newState, forKey: focusKey)
        defaults?.synchronize()
        return newState
    }
}
