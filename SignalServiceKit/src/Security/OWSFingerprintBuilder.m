//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import "OWSFingerprintBuilder.h"
#import "ContactsManagerProtocol.h"
#import "OWSFingerprint.h"
#import "OWSIdentityManager.h"
#import "TSAccountManager.h"
#import <Curve25519Kit/Curve25519.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSFingerprintBuilder ()

@property (nonatomic, readonly) TSAccountManager *accountManager;
@property (nonatomic, readonly) id<ContactsManagerProtocol> contactsManager;

@end

@implementation OWSFingerprintBuilder

- (instancetype)initWithAccountManager:(TSAccountManager *)accountManager
                       contactsManager:(id<ContactsManagerProtocol>)contactsManager
{
    self = [super init];
    if (!self) {
        return self;
    }

    _accountManager = accountManager;
    _contactsManager = contactsManager;

    return self;
}

- (nullable OWSFingerprint *)fingerprintWithTheirSignalId:(NSString *)theirSignalId
{
    NSData *_Nullable theirIdentityKey = [[OWSIdentityManager sharedManager] identityKeyForRecipientId:theirSignalId];

    if (theirIdentityKey == nil) {
        OWSFail(@"%@ Missing their identity key", self.logTag);
        return nil;
    }

    return [self fingerprintWithTheirSignalId:theirSignalId theirIdentityKey:theirIdentityKey];
}

- (OWSFingerprint *)fingerprintWithTheirSignalId:(NSString *)theirSignalId theirIdentityKey:(NSData *)theirIdentityKey
{
    NSString *theirName = [self.contactsManager displayNameForPhoneIdentifier:theirSignalId];

    NSString *mySignalId = [self.accountManager localNumber];
    NSData *myIdentityKey = [[OWSIdentityManager sharedManager] identityKeyPair].publicKey;

    return [OWSFingerprint fingerprintWithMyStableId:mySignalId
                                       myIdentityKey:myIdentityKey
                                       theirStableId:theirSignalId
                                    theirIdentityKey:theirIdentityKey
                                           theirName:theirName];
}

@end

NS_ASSUME_NONNULL_END
