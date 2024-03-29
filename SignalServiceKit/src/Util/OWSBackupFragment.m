//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSBackupFragment.h"

NS_ASSUME_NONNULL_BEGIN

@implementation OWSBackupFragment

- (void)saveWithTransaction:(YapDatabaseReadWriteTransaction *)transaction
{
    OWSAssert(self.recordName.length > 0);

    if (!self.uniqueId) {
        self.uniqueId = self.recordName;
    }
    [super saveWithTransaction:transaction];
}

@end

NS_ASSUME_NONNULL_END
