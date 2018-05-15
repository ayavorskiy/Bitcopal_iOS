//
//  Created by Ilya Kostyukevich. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (OWS)

#pragma mark - Logging

@property (nonatomic, readonly) NSString *logTag;

+ (NSString *)logTag;

+ (BOOL)isNullableObject:(nullable NSObject *)left equalTo:(nullable NSObject *)right;

@end

NS_ASSUME_NONNULL_END
