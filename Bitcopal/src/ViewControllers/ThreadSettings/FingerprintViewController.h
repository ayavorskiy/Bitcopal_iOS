//
//  Created by Ilya Kostyukevich. All rights reserved.
//

#import <SignalMessaging/OWSViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface FingerprintViewController : OWSViewController

+ (void)presentFromViewController:(UIViewController *)viewController recipientId:(NSString *)recipientId;

@end

NS_ASSUME_NONNULL_END