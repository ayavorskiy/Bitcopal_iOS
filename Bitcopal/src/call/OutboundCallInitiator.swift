//
//  Created by Ilya Kostyukevich. All rights reserved.
//

import Foundation
import SignalServiceKit
import SignalMessaging

/**
 * Creates an outbound call via WebRTC.
 */
@objc class OutboundCallInitiator: NSObject {
    let TAG = "[OutboundCallInitiator]"

    let contactsManager: OWSContactsManager
    let contactsUpdater: ContactsUpdater

    init(contactsManager: OWSContactsManager, contactsUpdater: ContactsUpdater) {
        self.contactsManager = contactsManager
        self.contactsUpdater = contactsUpdater

        super.init()

        SwiftSingletons.register(self)
    }

    /**
     * |handle| is a user formatted phone number, e.g. from a system contacts entry
     */
    public func initiateCall(handle: String) -> Bool {
        Logger.info("\(TAG) in \(#function) with handle: \(handle)")

        guard let recipientId = PhoneNumber(fromE164: handle)?.toE164() else {
            Logger.warn("\(TAG) unable to parse signalId from phone number: \(handle)")
            return false
        }

        return initiateCall(recipientId: recipientId, isVideo: false)
    }

    /**
     * |recipientId| is a e164 formatted phone number.
     */
    public func initiateCall(recipientId: String,
        isVideo: Bool) -> Bool {
        // Rather than an init-assigned dependency property, we access `callUIAdapter` via Environment
        // because it can change after app launch due to user settings
        guard let callUIAdapter = SignalApp.shared().callUIAdapter else {
            owsFail("\(TAG) can't initiate call because callUIAdapter is nil")
            return false
        }
        guard let frontmostViewController = UIApplication.shared.frontmostViewController else {
            owsFail("\(TAG) could not identify frontmostViewController in \(#function)")
            return false
        }

        let showedAlert = SafetyNumberConfirmationAlert.presentAlertIfNecessary(recipientId: recipientId,
                                                                                confirmationText: CallStrings.confirmAndCallButtonTitle,
                                                                                contactsManager: self.contactsManager,
                                                                                completion: { didConfirmIdentity in
                                                                                    if didConfirmIdentity {
                                                                                        _ = self.initiateCall(recipientId: recipientId, isVideo: isVideo)
                                                                                    }
        })
        guard !showedAlert else {
            return false
        }

        // Check for microphone permissions
        // Alternative way without prompting for permissions:
        // if AVAudioSession.sharedInstance().recordPermission() == .denied {
        frontmostViewController.ows_ask(forMicrophonePermissions: { [weak self] granted in
            // Success callback; camera permissions are granted.

            guard let strongSelf = self else {
                return
            }

            // Here the permissions are either granted or denied
            guard granted == true else {
                Logger.warn("\(strongSelf.TAG) aborting due to missing microphone permissions.")
                OWSAlerts.showNoMicrophonePermissionAlert()
                return
            }
            callUIAdapter.startAndShowOutgoingCall(recipientId: recipientId, hasLocalVideo: isVideo)
        })

        return true
    }
}