//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSAsserts.h"

NS_ASSUME_NONNULL_BEGIN

void SwiftAssertIsOnMainThread(NSString *functionName)
{
    if (![NSThread isMainThread]) {
        OWSCFail(@"%@ not on main thread", functionName);
    }
}

NS_ASSUME_NONNULL_END
