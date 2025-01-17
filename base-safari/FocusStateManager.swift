import Foundation
import os.log

class FocusStateManager {
    static let shared = FocusStateManager()
    private let logger = Logger(subsystem: "dev.nikiv.baseSafari", category: "FocusStateManager")

    // Store focus state in memory
    private var isInFocus: Bool = true

    // Add file watcher properties
    private var fileHandle: FileHandle?
    private var source: DispatchSourceFileSystemObject?

    private init() {
        startWatchingFocusFile()
    }

    /// Returns `true` if focus (blocking) is currently enabled.
    func isFocusEnabled() -> Bool {
        return isInFocus
    }

    /// Sets the focus state
    private func setFocusEnabled(_ enabled: Bool) {
        logger.notice("Setting focus enabled: \(enabled)")
        print("Setting focus enabled:", enabled)
        isInFocus = enabled
    }

    /// Toggle focus state and return new value
    func toggleFocusState() -> Bool {
        let newState = !isInFocus
        setFocusEnabled(newState)
        return newState
    }

    /// Gets path to focus file in shared container
    private func getFocusFilePath() -> String {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.nikiv.baseSafari")!
        return containerURL.appendingPathComponent(".currently-focused").path
    }

    /// Starts watching focus file for changes
    func startWatchingFocusFile() {
        let focusFilePath = getFocusFilePath()

        logger.notice("Starting to watch file at: \(focusFilePath)")
        print("Starting to watch file at:", focusFilePath)

        // Create file if it doesn't exist
        if !FileManager.default.fileExists(atPath: focusFilePath) {
            do {
                try "false".write(to: URL(fileURLWithPath: focusFilePath), atomically: true, encoding: .utf8)
                logger.notice("Created focus file")
                print("Created focus file")
            } catch {
                logger.error("Failed to create focus file: \(error.localizedDescription)")
                print("Failed to create focus file:", error)
                return
            }
        }

        // Set up file watching
        do {
            let fileHandle = try FileHandle(forReadingFrom: URL(fileURLWithPath: focusFilePath))
            self.fileHandle = fileHandle

            let source = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fileHandle.fileDescriptor,
                eventMask: [.write, .delete],
                queue: .main
            )

            source.setEventHandler { [weak self] in
                print("File change detected!")
                self?.readFromFocusFile()
            }

            source.setCancelHandler { [weak self] in
                self?.fileHandle?.closeFile()
                self?.fileHandle = nil
            }

            source.resume()
            self.source = source

            // Initial read
            readFromFocusFile()

        } catch {
            logger.error("Failed to set up file watching: \(error.localizedDescription)")
            print("Failed to set up file watching:", error)
        }
    }

    /// Reads the focus state from focus file
    private func readFromFocusFile() {
        let focusFilePath = getFocusFilePath()

        do {
            let contents = try String(contentsOf: URL(fileURLWithPath: focusFilePath)).trimmingCharacters(in: .whitespacesAndNewlines)
            let isFocused = contents.lowercased() == "true"
            logger.notice("Read focus state from file: \(isFocused)")
            print("Read focus state from file:", isFocused)
            setFocusEnabled(isFocused)
        } catch {
            logger.error("Failed to read focus file: \(error.localizedDescription)")
            print("Failed to read focus file:", error)
        }
    }

    deinit {
        source?.cancel()
    }
}
