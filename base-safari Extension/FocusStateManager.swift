import Foundation

class FocusStateManager {
    static let shared = FocusStateManager()
    private var isInFocus: Bool = true

    private init() {}

    func isFocusEnabled() -> Bool {
        return isInFocus
    }

    func toggleFocusState() -> Bool {
        isInFocus = !isInFocus
        return isInFocus
    }
}
