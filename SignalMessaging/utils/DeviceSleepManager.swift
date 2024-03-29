//
//  Created by Ilya Kostyukevich. All rights reserved.
//

import Foundation
import SignalServiceKit

// This entity has responsibility for blocking the device from sleeping if
// certain behaviors (e.g. recording or playing voice messages) are in progress.
// 
// Sleep blocking is keyed using "block objects" whose lifetime corresponds to
// the duration of the block.  For example, sleep blocking during audio playback
// can be keyed to the audio player.  This provides a measure of robustness.
// On the one hand, we can use weak references to track block objects and stop
// blocking if the block object is deallocated even if removeBlock() is not
// called.  On the other hand, we will also get correct behavior to addBlock()
// being called twice with the same block object.
@objc
public class DeviceSleepManager: NSObject {

    let TAG = "[DeviceSleepManager]"

    public static let sharedInstance = DeviceSleepManager()

    private class SleepBlock: CustomDebugStringConvertible {
        weak var blockObject: NSObject?

        var debugDescription: String {
            return "SleepBlock(\(String(reflecting: blockObject)))"
        }

        init(blockObject: NSObject) {
            self.blockObject = blockObject
        }
    }
    private var blocks: [SleepBlock] = []

    private override init() {
        super.init()

        SwiftSingletons.register(self)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground),
                                               name: NSNotification.Name.OWSApplicationDidEnterBackground,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func didEnterBackground() {
        SwiftAssertIsOnMainThread(#function)

        ensureSleepBlocking()
    }

    public func addBlock(blockObject: NSObject) {
        SwiftAssertIsOnMainThread(#function)

        blocks.append(SleepBlock(blockObject: blockObject))

        ensureSleepBlocking()
    }

    public func removeBlock(blockObject: NSObject) {
        SwiftAssertIsOnMainThread(#function)

        blocks = blocks.filter {
            $0.blockObject != nil && $0.blockObject != blockObject
        }

        ensureSleepBlocking()
    }

    private func ensureSleepBlocking() {
        SwiftAssertIsOnMainThread(#function)

        // Cull expired blocks.
        blocks = blocks.filter {
            $0.blockObject != nil
        }
        let shouldBlock = blocks.count > 0

        CurrentAppContext().ensureSleepBlocking(shouldBlock, blockingObjects: blocks)
    }
}
