//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "YapDatabaseTransaction+OWS.h"
#import <AxolotlKit/PreKeyRecord.h>
#import <AxolotlKit/SignedPrekeyRecord.h>
#import <Curve25519Kit/Curve25519.h>

NS_ASSUME_NONNULL_BEGIN

@implementation YapDatabaseReadTransaction (OWS)

- (nullable id)objectForKey:(NSString *)key inCollection:(NSString *)collection ofExpectedType:(Class) class {
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    id _Nullable value = [self objectForKey:key inCollection:collection];
    OWSAssert(!value || [value isKindOfClass:class]);
    return value;
}

    - (nullable NSDictionary *)dictionaryForKey : (NSString *)key inCollection : (NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    return [self objectForKey:key inCollection:collection ofExpectedType:[NSDictionary class]];
}

- (nullable NSString *)stringForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    return [self objectForKey:key inCollection:collection ofExpectedType:[NSString class]];
}

- (BOOL)boolForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    return [self boolForKey:key inCollection:collection defaultValue:NO];
}

- (BOOL)boolForKey:(NSString *)key inCollection:(NSString *)collection defaultValue:(BOOL)defaultValue
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    NSNumber *_Nullable value = [self objectForKey:key inCollection:collection ofExpectedType:[NSNumber class]];
    return value ? [value boolValue] : defaultValue;
}

- (nullable NSData *)dataForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    return [self objectForKey:key inCollection:collection ofExpectedType:[NSData class]];
}

- (nullable ECKeyPair *)keyPairForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    return [self objectForKey:key inCollection:collection ofExpectedType:[ECKeyPair class]];
}

- (nullable PreKeyRecord *)preKeyRecordForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    return [self objectForKey:key inCollection:collection ofExpectedType:[PreKeyRecord class]];
}

- (nullable SignedPreKeyRecord *)signedPreKeyRecordForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    return [self objectForKey:key inCollection:collection ofExpectedType:[SignedPreKeyRecord class]];
}

- (int)intForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    NSNumber *_Nullable number = [self objectForKey:key inCollection:collection ofExpectedType:[NSNumber class]];
    return [number intValue];
}

- (nullable NSDate *)dateForKey:(NSString *)key inCollection:(NSString *)collection
{
    OWSAssert(key.length > 0);
    OWSAssert(collection.length > 0);

    NSNumber *_Nullable value = [self objectForKey:key inCollection:collection ofExpectedType:[NSNumber class]];
    if (value) {
        return [NSDate dateWithTimeIntervalSince1970:value.doubleValue];
    } else {
        return nil;
    }
}

@end

#pragma mark -

@implementation YapDatabaseReadWriteTransaction (OWS)

#pragma mark - Debug

#if DEBUG
- (void)snapshotCollection:(NSString *)collection snapshotFilePath:(NSString *)snapshotFilePath
{
    OWSAssert(collection.length > 0);
    OWSAssert(snapshotFilePath.length > 0);

    NSMutableDictionary<NSString *, id> *snapshot = [NSMutableDictionary new];
    [self enumerateKeysAndObjectsInCollection:collection
                                   usingBlock:^(NSString *_Nonnull key, id _Nonnull value, BOOL *_Nonnull stop) {
                                       snapshot[key] = value;
                                   }];
    NSData *_Nullable data = [NSKeyedArchiver archivedDataWithRootObject:snapshot];
    OWSAssert(data);
    BOOL success = [data writeToFile:snapshotFilePath atomically:YES];
    OWSAssert(success);
}

- (void)restoreSnapshotOfCollection:(NSString *)collection snapshotFilePath:(NSString *)snapshotFilePath
{
    OWSAssert(collection.length > 0);
    OWSAssert(snapshotFilePath.length > 0);

    NSData *_Nullable data = [NSData dataWithContentsOfFile:snapshotFilePath];
    OWSAssert(data);
    NSMutableDictionary<NSString *, id> *_Nullable snapshot = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    OWSAssert(snapshot);

    [self removeAllObjectsInCollection:collection];
    [snapshot enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id _Nonnull value, BOOL *_Nonnull stop) {
        [self setObject:value forKey:key inCollection:collection];
    }];
}
#endif

@end

NS_ASSUME_NONNULL_END
