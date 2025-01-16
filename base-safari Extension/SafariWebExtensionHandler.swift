//
//  SafariWebExtensionHandler.swift
//  base-safari Extension
//
//  Created by Nikita on 25/12/24.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    private var isBlocked: Bool = false

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let profile: UUID?
        if #available(iOS 17.0, macOS 14.0, *) {
            profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = request?.userInfo?["profile"] as? UUID
        }

        let message: Any?
        if #available(iOS 15.0, macOS 11.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }

        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@ (profile: %@)", String(describing: message), profile?.uuidString ?? "none")

        let item = request
        let commandMessage = item?.userInfo?[SFExtensionMessageKey] as? [String: Any]
        
        guard let command = commandMessage?["command"] as? String else {
            let response = NSExtensionItem()
            if #available(iOS 15.0, macOS 11.0, *) {
                response.userInfo = [ SFExtensionMessageKey: [ "echo": message ] ]
            } else {
                response.userInfo = [ "message": [ "echo": message ] ]
            }
            context.completeRequest(returningItems: [ response ], completionHandler: nil)
            return
        }
        
        let response = NSExtensionItem()
        
        switch command {
        case "getBlockStatus":
            // Respond with current block status
            response.userInfo = [ SFExtensionMessageKey: ["command": "checkBlockStatus", "isBlocked": isBlocked] ]
            
        case "toggleBlock":
            // Toggle blocking state
            isBlocked.toggle()
            response.userInfo = [ SFExtensionMessageKey: ["command": "checkBlockStatus", "isBlocked": isBlocked] ]
            
        default:
            if #available(iOS 15.0, macOS 11.0, *) {
                response.userInfo = [ SFExtensionMessageKey: [ "echo": message ] ]
            } else {
                response.userInfo = [ "message": [ "echo": message ] ]
            }
        }
        
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

}
