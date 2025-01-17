import Foundation

class FocusStateManager {
    static let shared = FocusStateManager()

    private let suiteName = "group.dev.nikiv.baseSafari"
    private let focusKey = "focusEnabled"

    // Add file watcher properties
    private var fileHandle: FileHandle?
    private var source: DispatchSourceFileSystemObject?

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

    /// Starts watching ~/.currently-focused for changes
    func startWatchingFocusFile() {
        let homeURL = FileManager.default.homeDirectoryForCurrentUser
        let focusFileURL = homeURL.appendingPathComponent(".currently-focused")

        // Create file if it doesn't exist
        if !FileManager.default.fileExists(atPath: focusFileURL.path) {
            try? "false".write(to: focusFileURL, atomically: true, encoding: .utf8)
        }

        // Set up file watching
        guard let fileHandle = try? FileHandle(forReadingFrom: focusFileURL) else { return }
        self.fileHandle = fileHandle

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileHandle.fileDescriptor,
            eventMask: .write,
            queue: .main
        )

        source.setEventHandler { [weak self] in
            self?.readFromFocusFile()
        }

        source.resume()
        self.source = source

        // Initial read
        readFromFocusFile()
    }

    /// Reads the focus state from ~/.currently-focused
    private func readFromFocusFile() {
        let homeURL = FileManager.default.homeDirectoryForCurrentUser
        let focusFileURL = homeURL.appendingPathComponent(".currently-focused")

        if let contents = try? String(contentsOf: focusFileURL).trimmingCharacters(in: .whitespacesAndNewlines) {
            let isFocused = contents.lowercased() == "true"
            setFocusEnabled(isFocused)
        }
    }
}
