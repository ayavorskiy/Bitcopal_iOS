//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import <Mantle/MTLModel.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An adapter for the system contacts
 */

@class CNContact;
@class PhoneNumber;
@class SignalRecipient;
@class UIImage;
@class YapDatabaseReadTransaction;

@interface Contact : MTLModel

@property (nullable, readonly, nonatomic) NSString *firstName;
@property (nullable, readonly, nonatomic) NSString *lastName;
@property (readonly, nonatomic) NSString *fullName;
@property (readonly, nonatomic) NSString *comparableNameFirstLast;
@property (readonly, nonatomic) NSString *comparableNameLastFirst;
@property (readonly, nonatomic) NSArray<PhoneNumber *> *parsedPhoneNumbers;
@property (readonly, nonatomic) NSArray<NSString *> *userTextPhoneNumbers;
@property (readonly, nonatomic) NSArray<NSString *> *emails;
@property (readonly, nonatomic) NSString *uniqueId;
@property (nonatomic, readonly) BOOL isSignalContact;
#if TARGET_OS_IOS
@property (nullable, readonly, nonatomic) UIImage *image;
@property (nullable, readonly, nonatomic) NSData *imageData;
@property (nullable, nonatomic, readonly) CNContact *cnContact;
#endif // TARGET_OS_IOS

- (NSArray<SignalRecipient *> *)signalRecipientsWithTransaction:(YapDatabaseReadTransaction *)transaction;
// TODO: Remove this method.
- (NSArray<NSString *> *)textSecureIdentifiers;

#if TARGET_OS_IOS

- (instancetype)initWithSystemContact:(CNContact *)contact NS_AVAILABLE_IOS(9_0);
+ (nullable Contact *)contactWithVCardData:(NSData *)data;

- (NSString *)nameForPhoneNumber:(NSString *)recipientId;

#endif // TARGET_OS_IOS

+ (NSComparator)comparatorSortingNamesByFirstThenLast:(BOOL)firstNameOrdering;
+ (NSString *)formattedFullNameWithCNContact:(CNContact *)cnContact NS_SWIFT_NAME(formattedFullName(cnContact:));

- (CNContact *)buildCNContactMergedWithNewContact:(CNContact *)newCNContact NS_SWIFT_NAME(buildCNContact(mergedWithNewContact:));

@end

NS_ASSUME_NONNULL_END
