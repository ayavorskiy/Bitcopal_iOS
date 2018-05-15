//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSPrimaryStorage.h"

@interface OWSPrimaryStorage (messageIDs)

+ (NSString *)getAndIncrementMessageIdWithTransaction:(YapDatabaseReadWriteTransaction *)transaction;

@end
