import SafariServices
import os.log
import Foundation

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems.first as? NSExtensionItem

        // Get user profile info
        let profile: UUID?
        if #available(iOS 17.0, macOS 14.0, *) {
            profile = item?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = item?.userInfo?["profile"] as? UUID
        }

        // Log messages for debugging
        let message: Any?
        if #available(iOS 15.0, macOS 11.0, *) {
            message = item?.userInfo?[SFExtensionMessageKey]
        } else {
            message = item?.userInfo?["message"]
        }
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@ (profile: %@)", String(describing: message), profile?.uuidString ?? "none")

        // Get command from message
        let commandMessage = item?.userInfo?[SFExtensionMessageKey] as? [String: Any]
        guard let command = commandMessage?["command"] as? String else {
            let response = NSExtensionItem()
            response.userInfo = [ SFExtensionMessageKey: [ "echo": message ] ]
            context.completeRequest(returningItems: [response], completionHandler: nil)
            return
        }

        let response = NSExtensionItem()

        switch command {
        case "getBlockStatus":
            // Get current focus state from shared manager
            let isBlocked = FocusStateManager.shared.isFocusEnabled()
            response.userInfo = [ SFExtensionMessageKey: ["command": "checkBlockStatus", "isBlocked": isBlocked] ]

        case "toggleBlock":
            // Toggle state and get new value
            let isBlocked = FocusStateManager.shared.toggleFocusState()
            response.userInfo = [ SFExtensionMessageKey: ["command": "checkBlockStatus", "isBlocked": isBlocked] ]

        default:
            response.userInfo = [ SFExtensionMessageKey: [ "echo": message ] ]
        }

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
