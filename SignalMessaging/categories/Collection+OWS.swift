//
//  Created by Ilya Kostyukevich. All rights reserved.
//

public extension Collection {

    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
