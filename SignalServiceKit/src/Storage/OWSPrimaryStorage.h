//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWSPrimaryStorage : OWSStorage

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)sharedManager NS_SWIFT_NAME(shared());

- (YapDatabaseConnection *)dbReadConnection;
- (YapDatabaseConnection *)dbReadWriteConnection;
+ (YapDatabaseConnection *)dbReadConnection;
+ (YapDatabaseConnection *)dbReadWriteConnection;

+ (nullable NSError *)migrateToSharedData;

+ (NSString *)databaseFilePath;

+ (NSString *)legacyDatabaseFilePath;
+ (NSString *)legacyDatabaseFilePath_SHM;
+ (NSString *)legacyDatabaseFilePath_WAL;
+ (NSString *)sharedDataDatabaseFilePath;
+ (NSString *)sharedDataDatabaseFilePath_SHM;
+ (NSString *)sharedDataDatabaseFilePath_WAL;

@end

NS_ASSUME_NONNULL_END
