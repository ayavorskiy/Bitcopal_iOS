//
//  Created by Ilya Kostyukevich. All rights reserved.
//

import Foundation

public extension String {

    // Truncates string to be less than or equal to byteCount, while ensuring we never truncate partial characters for multibyte characters.
    public func truncated(toByteCount byteCount: UInt) -> String? {
        var lowerBoundCharCount = 0
        var upperBoundCharCount = self.count

        while (lowerBoundCharCount < upperBoundCharCount) {
            guard let upperBoundData = self.prefix(upperBoundCharCount).data(using: .utf8) else {
                owsFail("in \(#function) upperBoundData was unexpectedly nil")
                return nil
            }

            if upperBoundData.count <= byteCount {
                break
            }

            // converge
            if upperBoundCharCount - lowerBoundCharCount == 1 {
                upperBoundCharCount = lowerBoundCharCount
                break
            }

            let midpointCharCount = (lowerBoundCharCount + upperBoundCharCount) / 2
            let midpointString = self.prefix(midpointCharCount)

            guard let midpointData = midpointString.data(using: .utf8) else {
                owsFail("in \(#function) midpointData was unexpectedly nil")
                return nil
            }
            let midpointByteCount = midpointData.count

            if midpointByteCount < byteCount {
                lowerBoundCharCount = midpointCharCount
            } else {
                upperBoundCharCount = midpointCharCount
            }
        }

        return String(self.prefix(upperBoundCharCount))
    }

}
