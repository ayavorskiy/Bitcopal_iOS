//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWS108CallLoggingPreference.h"
#import "Environment.h"
#import "OWSPreferences.h"
#import <YapDatabase/YapDatabaseTransaction.h>

NS_ASSUME_NONNULL_BEGIN

// Increment a similar constant for every future DBMigration
static NSString *const OWS108CallLoggingPreferenceId = @"108";

@implementation OWS108CallLoggingPreference

+ (NSString *)migrationId
{
    return OWS108CallLoggingPreferenceId;
}

- (void)runUpWithTransaction:(YapDatabaseReadWriteTransaction *)transaction
{
    OWSAssert(transaction);

    [[Environment preferences] applyCallLoggingSettingsForLegacyUsersWithTransaction:transaction];
}

@end

NS_ASSUME_NONNULL_END
