import Foundation

class FocusStateManager {
    static let shared = FocusStateManager()
    
    private let suiteName = "group.dev.nikiv.baseSafari"
    private let focusKey = "focusEnabled"
    
    private init() {}
    
    /// Returns `true` if focus (blocking) is currently enabled.
    func isFocusEnabled() -> Bool {
        let defaults = UserDefaults(suiteName: suiteName)
        return defaults?.bool(forKey: focusKey) ?? false
    }
    
    /// Sets the focus (blocking) state in the shared container.
    func setFocusEnabled(_ enabled: Bool) {
        let defaults = UserDefaults(suiteName: suiteName)
        defaults?.set(enabled, forKey: focusKey)
        defaults?.synchronize()
    }
    
    /// Toggle focus state and return new value
    func toggleFocusState() -> Bool {
        let newState = !isFocusEnabled()
        setFocusEnabled(newState)
        return newState
    }
}