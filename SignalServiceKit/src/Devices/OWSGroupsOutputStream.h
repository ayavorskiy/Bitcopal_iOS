//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSChunkedOutputStream.h"

NS_ASSUME_NONNULL_BEGIN

@class TSGroupThread;
@class YapDatabaseReadTransaction;

@interface OWSGroupsOutputStream : OWSChunkedOutputStream

- (void)writeGroup:(TSGroupThread *)groupThread transaction:(YapDatabaseReadTransaction *)transaction;

@end

NS_ASSUME_NONNULL_END
