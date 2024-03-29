//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWS100RemoveTSRecipientsMigration.h"
#import <YapDatabase/YapDatabaseTransaction.h>

NS_ASSUME_NONNULL_BEGIN

// Increment a similar constant for every future DBMigration
static NSString *const OWS100RemoveTSRecipientsMigrationId = @"100";

@implementation OWS100RemoveTSRecipientsMigration

+ (NSString *)migrationId
{
    return OWS100RemoveTSRecipientsMigrationId;
}

- (void)runUpWithTransaction:(YapDatabaseReadWriteTransaction *)transaction
{
    OWSAssert(transaction);

    NSUInteger legacyRecipientCount = [transaction numberOfKeysInCollection:@"TSRecipient"];
    DDLogWarn(@"Removing %lu objects from TSRecipient collection", (unsigned long)legacyRecipientCount);
    [transaction removeAllObjectsInCollection:@"TSRecipient"];
}

@end

NS_ASSUME_NONNULL_END
