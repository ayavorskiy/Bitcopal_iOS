//
//  Created by Ilya Kostyukevich. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSError (MessageSending)

@property (nonatomic) BOOL isRetryable;
@property (nonatomic) BOOL isFatal;
@property (nonatomic) BOOL shouldBeIgnoredForGroups;

@end

NS_ASSUME_NONNULL_END
