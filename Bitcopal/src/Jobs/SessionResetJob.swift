//
//  Created by Ilya Kostyukevich. All rights reserved.
//

import Foundation
import PromiseKit
import SignalServiceKit

@objc(OWSSessionResetJob)
class SessionResetJob: NSObject {

    let TAG = "SessionResetJob"

    let recipientId: String
    let thread: TSThread
    let primaryStorage: OWSPrimaryStorage
    let messageSender: MessageSender

    required init(recipientId: String, thread: TSThread, messageSender: MessageSender, primaryStorage: OWSPrimaryStorage) {
        self.thread = thread
        self.recipientId = recipientId
        self.messageSender = messageSender
        self.primaryStorage = primaryStorage
    }

    func run() {
        Logger.info("\(TAG) Local user reset session.")

        let dbConnection = OWSPrimaryStorage.shared().newDatabaseConnection()
        dbConnection.asyncReadWrite { (transaction) in
            Logger.info("\(self.TAG) deleting sessions for recipient: \(self.recipientId)")
            self.primaryStorage.deleteAllSessions(forContact: self.recipientId, protocolContext: transaction)

            DispatchQueue.main.async {
                let endSessionMessage = EndSessionMessage(timestamp: NSDate.ows_millisecondTimeStamp(), in: self.thread)

                self.messageSender.enqueue(endSessionMessage, success: {
                    dbConnection.asyncReadWrite { (transaction) in
                        // Archive the just-created session since the recipient should delete their corresponding
                        // session upon receiving and decrypting our EndSession message.
                        // Otherwise if we send another message before them, they wont have the session to decrypt it.
                        self.primaryStorage.archiveAllSessions(forContact: self.recipientId, protocolContext: transaction)
                    }
                    Logger.info("\(self.TAG) successfully sent EndSessionMessage.")
                    let message = TSInfoMessage(timestamp: NSDate.ows_millisecondTimeStamp(),
                                                in: self.thread,
                                                messageType: TSInfoMessageType.typeSessionDidEnd)
                    message.save()
                }, failure: {error in
                    dbConnection.asyncReadWrite { (transaction) in
                        // Even though this is the error handler - which means probably the recipient didn't receive the message
                        // there's a chance that our send did succeed and the server just timed out our repsonse or something.
                        // Since the cost of sending a future message using a session the recipient doesn't have is so high,
                        // we archive the session just in case.
                        //
                        // Archive the just-created session since the recipient should delete their corresponding
                        // session upon receiving and decrypting our EndSession message.
                        // Otherwise if we send another message before them, they wont have the session to decrypt it.
                        self.primaryStorage.archiveAllSessions(forContact: self.recipientId, protocolContext: transaction)
                    }
                    Logger.error("\(self.TAG) failed to send EndSessionMessage with error: \(error.localizedDescription)")
                })
            }
            }
        }

    class func run(contactThread: TSContactThread, messageSender: MessageSender, primaryStorage: OWSPrimaryStorage) {
        let job = self.init(recipientId: contactThread.contactIdentifier(),
                            thread: contactThread,
                            messageSender: messageSender,
                            primaryStorage: primaryStorage)
        job.run()
    }
}
